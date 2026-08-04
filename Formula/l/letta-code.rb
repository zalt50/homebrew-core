class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.3.tgz"
  sha256 "10beea557b3169b7781953f2865d987b7a783915971a63ab31b86f8df927f532"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "698672374ff6c860c4ac5d0f3ac3581398499aa5f6cfc1ad297b548f288d5112"
    sha256               arm64_sequoia: "ec688654c173749b4a6c727d1d55dc27b20f829fef130fcee74f703cb4928486"
    sha256               arm64_sonoma:  "824fa7ff3f53ade5cf254d0dc295df881e369126d0971bd2a7d0c3c41cf8e4c8"
    sha256               sonoma:        "e7635d74e70963646cfc2c3ec148c647780bb07dce450f414680ae0b6bc84c58"
    sha256 cellar: :any, arm64_linux:   "00ca12895c992d003af8612129f5c21956c757ead7108e776f0726f99e9a6406"
    sha256 cellar: :any, x86_64_linux:  "3a6c4a511bb5b555ec8f8efaa968a83f41695b31c539df15df11437d52ac5197"
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
