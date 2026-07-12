class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.2.tgz"
  sha256 "2a323b21b6c0268f3d22271a723b309ec5b244754e9b239ab057761990b2b46c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "33d42d1c892d122c965e0df182c5619cd70c3b5be72b5d6a6242a0e617c49eac"
    sha256               arm64_sequoia: "6d344858b88527064ce13e578f6abb865182de88c327bfabf3563c5308866388"
    sha256               arm64_sonoma:  "02bb1b44ed93153a8f2abbb69cd97d30d1410c9e8fcba84167bc951821da75f1"
    sha256               sonoma:        "802171ab05e4cc81bb93f0513b0db7da0d8b709f66cd63ea8229f976704fb4c6"
    sha256 cellar: :any, arm64_linux:   "d028a4a7768c144de7d4b15721da3dd0c811d1b7fd34cfa98cba6fdcc1ef190a"
    sha256 cellar: :any, x86_64_linux:  "b22f3641ac4511a23b2c42e31cae93f7cf0c07c084b4f8f682145787ccf88147"
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
