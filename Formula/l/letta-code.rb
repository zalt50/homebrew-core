class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.12.tgz"
  sha256 "5f457d45e7850a5c74b8ada508153930bd6c02a46bd67cda5d888179ec2aa53e"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "553f44addcdcb435b9aa436ac60be0b49b8f82584dda0e39da17905e79d5da7d"
    sha256               arm64_sequoia: "cf76bacdb3d86d95f533fa2b8d56f8afe79cba94ff2fa5b75935a625a512917a"
    sha256               arm64_sonoma:  "fbacb65a6700f5c30b647b681a273a1cf616df7855c46038e3f42c1358bbd01b"
    sha256               sonoma:        "d78d6dc921b722144235edd74b45889f88e495b2f34dc4016d2bbcfa1599b932"
    sha256 cellar: :any, arm64_linux:   "5f7ba3fd1042adcded6534a2f7cb058e7d44bc90d417bda062f4a5fe2c13adaa"
    sha256 cellar: :any, x86_64_linux:  "cf010a0c9879bad61b749cddf23c68e13443af68367b1b5f9d6da1d65b7dafb0"
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
