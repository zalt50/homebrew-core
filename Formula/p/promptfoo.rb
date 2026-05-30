class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.13.tgz"
  sha256 "4c35b711a22d38dd7ac4dc381851ffb009a053e287055faca3f178eec5bd544f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1243cfa00971fdaa1a9a5d4beaa34e7d19347b9efd90ea3f3ff5a2db842e8e40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9808b2681b9e4085aa2cbe6f4550a46c6a18578557e78658afd7ab536dcc7656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d565d62c9fee3e6d174aebb69cd7d1f4f1cecb650d529a97be600293daa0b67a"
    sha256 cellar: :any_skip_relocation, sonoma:        "81c50e4b5bab55b0d7a5be05ffbeafb1f3b93c91ad51e86ac4d7e97ce369de5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6860604e84a13e70b19d9b2852c276e449e98fd8b50248ba60d99358b18873e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05e2f2cd06a650170a0f2f022d74ab7e0892fe1db0170b87364ceb9e48f74038"
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
