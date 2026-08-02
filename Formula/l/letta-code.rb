class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.1.tgz"
  sha256 "e829b59f6e80d928d9ef229835a0e33207c240f50e7d7892fddb4bc12f2c7f3c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "8924f0aed4911d654b73311cd38dd544ada83d9fc5e2e7eee6bda3135410d707"
    sha256               arm64_sequoia: "4f6160db137c76a69d8d9ee28dac5b319e096bf46b55e575f3e398324c2e32e9"
    sha256               arm64_sonoma:  "4029043180831cb1f486f582124800c5016cc271013a5728f6f0b1bfa2906df0"
    sha256               sonoma:        "2b0b0ee8f08b6b3afcde8be458e8974cc2ce75ded9e39e4181c00fab7779f88a"
    sha256 cellar: :any, arm64_linux:   "9ad574c85351eac9d9e1396e4c16062e1a6921e83c0c6e73aea5e0eadffa569b"
    sha256 cellar: :any, x86_64_linux:  "ae1fafa86f41024f56906021c9b6e53ebde1f176097f021b4c54be1371595f9f"
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
