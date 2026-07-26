class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.1.tgz"
  sha256 "b9bc78d2fc56b29e071732df8c1cb9e707cd4ed806c3cf284b13282c851dc23c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "f7d46b6e1864ca141308b1afdc52aab7687dc2ee233ccccc66d6a1f7ce75da4c"
    sha256               arm64_sequoia: "01005c765ae0a5a3ba2effc708a1e4d913de92f2c04f184b5090e24bb2d42450"
    sha256               arm64_sonoma:  "2293e3b7ff5b155f895e9b6ce5550f0c30f54b79145cb6a1030acf26f7d2e935"
    sha256               sonoma:        "ab6769ac1da4bdbb009e757ce3fba1e52a00f4d71d6a0240e0fcae9dd1c4dda3"
    sha256 cellar: :any, arm64_linux:   "16f8213a549d1859c618865a8a55d87af90fac4df6439c63469aa21811a2285a"
    sha256 cellar: :any, x86_64_linux:  "23807ffd92aa2deac056c466e81275c445e1c9d5d470d3cadaf6dd5f295d95f9"
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
