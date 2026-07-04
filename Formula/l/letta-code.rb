class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.23.tgz"
  sha256 "ca7ac47e00660eb549fa5d9553c881e09affcea14ce4e3716038b385f2e8d5ab"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ea1789eca9a63448eaf5ff35bf44b55dd7c321372621b87c77a30edfd8843e8e"
    sha256               arm64_sequoia: "cc36d94466d09ad4b6ec54ebe8ad355d41f5cd888f133d6b77050b0d4a771a8d"
    sha256               arm64_sonoma:  "3d57b89630c3bc4b3b70bdd9bb13b1483951c38900ad00c1e7175a95aa880526"
    sha256               sonoma:        "759bbe953b4cb7cb3871a4adf433386767c4c5104b9fe79d3fbb591906ca77e4"
    sha256 cellar: :any, arm64_linux:   "2af0d654c20e961f139c960818e423cf7ced13ed91a384174ddaa9e9fffec28f"
    sha256 cellar: :any, x86_64_linux:  "3d8d376d8bf676748370a954eb81c9b398c6f37a097f7477c0372fc032e13fb5"
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
