class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.1.tgz"
  sha256 "87812bab8cd8fef17ef131102fa926aa6528af6985171fd71c994e64a62523fd"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "c13b986db95601708bd020112b26cdacb3eac52af943e5912053d708fd3e9e85"
    sha256               arm64_sequoia: "9aff4eee82c6ce2f102b597e2a14d68dab28dda2b7770d77702fb2cb07317550"
    sha256               arm64_sonoma:  "c5b43d9d136011ee3486082e9158fec4dd98319f7cdfea200db2b7cde60ef0bb"
    sha256               sonoma:        "3a5373fae42231468f22c6d71fca94d6d337a44d8bb6de7d241b1a82364380e1"
    sha256 cellar: :any, arm64_linux:   "28d15e1a32826dc1d3b7100d8bfc2b18f7ac6ab9be14eaf8659a9eab5e62fa78"
    sha256 cellar: :any, x86_64_linux:  "ad36a4d97f07485ae97ead28bbe9d507c08023ca572885e4c86cda5b03c8fbf9"
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
