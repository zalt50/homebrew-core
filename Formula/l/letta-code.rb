class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.5.tgz"
  sha256 "1afa329997fab3c8fd2f9e77f4d65ef3841e7a2cece8cf3810a5f71a82a27c92"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "77745e696fa01b16918f5f3bc35df361b8dcf8e02db9fca7cee6016096172e12"
    sha256               arm64_sequoia: "1dba739ef7b6935c0310b8872be69e7371d3ee95280e14d7619e5e995c51aa09"
    sha256               arm64_sonoma:  "477cc4c0cea631ab7c7f47eb0b4a139aa555dc3e6d506277de00999cdcc30d69"
    sha256               sonoma:        "1ca8267272c1d9fe02372cf6b9e84efbfab55cdf519053d5066ea45c2c9db972"
    sha256 cellar: :any, arm64_linux:   "c8b0c44bb6b6990804402cc0303fa06f48bf90bf884a3702467798288f55ab0a"
    sha256 cellar: :any, x86_64_linux:  "1146958bc970f3d899aef728f7c16567472ac0032319da84886f13fa8fdcfd0d"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("@vscode/ripgrep-*"))
    rm_r(node_modules/"@vscode/ripgrep") # keeping separate from previous rm_r to fail if missing

    # Replace node-pty pre-built binaries
    cd node_modules/"node-pty" do
      rm_r(["prebuilds", "third_party"])
      system "npm", "run", "install"
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # help letta.js find source-built sharp
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
