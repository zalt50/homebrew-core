class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.11.tgz"
  sha256 "7f445aedaff59e55515d7f1f7be36e9d5ebb1eb64219785d6194886f2f540441"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "656ae528b886cb87bce9abd4c78ab836f3b80c57ff5304ee204bc6da4cc8c1fa"
    sha256               arm64_sequoia: "d5a2cdfd26b836c6fe0961c19a5527be7d2c2b8ca70a4d53ee33a1497f3abcf2"
    sha256               arm64_sonoma:  "b9767716b209f2e9da9ef5e1247d57e9715b8fb48867832a1dcd915cebc06b9e"
    sha256               sonoma:        "1251d904a0b1f5d26549b28d392cc2f91fc54667ff9a28a279df83e9b4f190af"
    sha256 cellar: :any, arm64_linux:   "69c8926d6066d8527c625a24456afb1febba07269113f4de9578aad0091f0f65"
    sha256 cellar: :any, x86_64_linux:  "831e4f2a9b2846a9d9992263d9f1a86d3466a27eacd0f4435dcbb5122ce80872"
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
