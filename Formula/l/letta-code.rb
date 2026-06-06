class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.4.tgz"
  sha256 "fe2b2ad44f2602a0e0d8bd5cb89dadab3445b6bec56fe308370ef1ebdcd6be03"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9cbd4ccab83a7d4e162892aa7c59aa8a7562835465bd98d5b3dcf16c3045745b"
    sha256               arm64_sequoia: "81d16269fa4b4bec2ed95bcbd4f763ad7100e9daa6e034a64c8a727cf23bdb40"
    sha256               arm64_sonoma:  "5d1a5c33ef9b9562b0093a7136d0d49de10ded8e75f98744b6528da109a82779"
    sha256               sonoma:        "5f839dbb4570c7a242073f05b20dda482f3c6637af9101673e1568dc0e6da892"
    sha256 cellar: :any, arm64_linux:   "1b081022d972b4897cdfb46c22e734b1db457a5b35cbbd754b886063e29510c6"
    sha256 cellar: :any, x86_64_linux:  "b0cb6e48295beff6f26a8961fd0300baf37f5f3c6f6ec5751692e951f9803c16"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.4.0.tgz"
    sha256 "c5651a4fa92942a36cf30e0f043119d4889e26e25f30ae28b8cecc16e705bf29"

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
