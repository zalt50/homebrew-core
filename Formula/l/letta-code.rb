class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.9.tgz"
  sha256 "62e6d4baeff3d634b36754ebbadc7a075473e6295bdfbaae659aee91cb148961"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "4e88cfaa95f503a3d5e08a3d53c1ae8d31ea889f928b0acfb23f7b5bfe8b308a"
    sha256               arm64_sequoia: "cc1523d9403826866406e8b5c178bea43a6d87cf55970948cbfcf3ff9afc84e5"
    sha256               arm64_sonoma:  "c5f929d118d69437becff2722322c270d2d01bf8c6f572ea77f4e3e5ce73b613"
    sha256               sonoma:        "e41607d884f3323f5d9c2e3220d639d31689abe00e4c757d8d6f2979b56858c0"
    sha256 cellar: :any, arm64_linux:   "e4b315e4d9d5dc934d48e41a85986effa4a45002804793ccbb5f4053593568ef"
    sha256 cellar: :any, x86_64_linux:  "43f724aab40fbba8048dc048c1a3b6e33ffff889caf0237cf60e480daf27e6d0"
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
