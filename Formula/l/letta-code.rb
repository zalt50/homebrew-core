class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.5.tgz"
  sha256 "62d60565b87ffd523433f703e07ea002a756aa2d166317cd7a5e5f6310593ac2"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "3beaa4a94131c0e98b333394418d41e65b73b700c05f3416769c36cb017459ae"
    sha256               arm64_sequoia: "b6cb79202f3f3d13e79eec86476da114681a44ceda8acb8e1c6d753a414ba7b5"
    sha256               arm64_sonoma:  "107c3e4928e9552f4f08efa962a5f6adf58b479485bf99960162e26b5795d33e"
    sha256               sonoma:        "dd4b2bb2e68e74048667439b48cdaec4415427b608029533bb4320d59cc30d5d"
    sha256 cellar: :any, arm64_linux:   "4f595b55e9c065ab16a16552350305f80a0b72cc70aeb0804c4cb5ee5c710ff4"
    sha256 cellar: :any, x86_64_linux:  "3625c3f549f3ad51f07e89ab7522b341a0a08ff3039faf0369cf5ed9d78487c3"
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
