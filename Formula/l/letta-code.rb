class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.29.tgz"
  sha256 "d504d02732c61240103add9eb4bdb0ac8fb3d6f5b178e8eeea79677bc8ac9c8c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "1daaa7730474bc98dce1e82172272f251158c8919dd7f117003bcf15aea4c754"
    sha256               arm64_sequoia: "fd6b500bd7ffc218cac592ba8baf349647dc63b125e7425a2e3648aff4dbb4c0"
    sha256               arm64_sonoma:  "01a817dc3855e5c29f4e1bbf4c61aee14836c8c540fcff130718eda5cb0eb76d"
    sha256               sonoma:        "27c655ab890cf053ac268748b194ed8fadb52fe57ae065c752a80995b5fba3aa"
    sha256 cellar: :any, arm64_linux:   "6e0a626c9f93c62e0e04a27dfcd54c1974e7d98fafd1a1013f358f755f95fd58"
    sha256 cellar: :any, x86_64_linux:  "6950842db6679da7dce6fbb985b2b8d2cb927f1e363dfe1fffbc41ca60dc4580"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"

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
    assert_match "Pinned agents: (none)", output
  end
end
