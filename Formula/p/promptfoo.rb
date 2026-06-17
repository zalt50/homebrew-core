class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.16.tgz"
  sha256 "152247637db3248050e91311b347d800beb24dd19f98beeebf24ce7f0f9a93ed"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bd05918d0ff3bf8cf756dcb072c961cef7738c2e8472179d659ac0ba048cf4af"
    sha256 cellar: :any, arm64_sequoia: "cf6b47eeefbf814c9d93d00ecbc565dc7397718730b798b92554eb761cd100b3"
    sha256 cellar: :any, arm64_sonoma:  "cc663321a6a480a1daab528eba1146e61f2499e177c6ee9472e5fcd989cd3b19"
    sha256 cellar: :any, sonoma:        "f765bedcf50a63cb3aa5020ec6f2c292574f3224b4d100489cc37a2b8a40a464"
    sha256 cellar: :any, arm64_linux:   "d479314ac6ce8fe49ae0e6e75eb6f62b6738e6834df87780d3d452bcdfd9fd61"
    sha256 cellar: :any, x86_64_linux:  "6fd3c27c7d47f0466dba1bfd8edf61ae5ea2ed4e750c4a48b8cc5b16b88dff34"
  end

  depends_on "cmake" => :build # for `libsql-js` > `libsql-ffi`
  depends_on "rust" => :build # for `libsql-js`
  depends_on "node"

  resource "libsql-js" do
    url "https://github.com/tursodatabase/libsql-js/archive/refs/tags/v0.5.29.tar.gz"
    sha256 "e7ccf7f0ade06158bac3f5fffe69d9707741940678aadec75319713e21b57c21"
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
      system "npm", "install", "--omit=dev", "--omit=optional", *std_npm_args(prefix: false)

      resource("libsql-js").stage do
        ENV.append_to_rustflags "--cfg tokio_unstable"
        system "cargo", "build", "--lib", "--release"

        arch = Hardware::CPU.arm? ? "arm64" : "x64"
        libsql_target = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}-gnu"
        binding_dir = libexec/"promptfoo/node_modules/@libsql/#{libsql_target}"

        binding_dir.install "target/release/#{shared_library("liblibsql_js")}" => "index.node"
      end

      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
