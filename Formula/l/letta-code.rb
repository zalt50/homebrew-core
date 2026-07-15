class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.7.tgz"
  sha256 "efdf31b1c192f19db01185efc97b7ddf6ad73921265ee886fdcb4de30e694bb3"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "2bfc62129859bbbb79a9cbf4baae0d05be8b56e57c91b1f1d4fa9241974cb91f"
    sha256               arm64_sequoia: "d3d692713d9fb234be8f8e3a1d31ec2138cd36b53464baf4f67416a2fa6863ab"
    sha256               arm64_sonoma:  "3d0d32bd7b235e7ec5766262311a076564a7c0d6df0915fafb85470c48c79273"
    sha256               sonoma:        "6bcd0c841116b1148befa6957a9ba491b7d9c0177c946653e300478c8e22cd75"
    sha256 cellar: :any, arm64_linux:   "6b343e580a93cf68b0408799e1f5e529f8bd2d60ce5594a9c17838741fde5062"
    sha256 cellar: :any, x86_64_linux:  "21b3a6181bd3647a2aff40cb99701fdea88aa9c4eb565f0ced85b69db5700aed"
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
