class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.10.tgz"
  sha256 "fd365c752770d8b8b17c357f7cecd36423c404e185a74706f159a21a79d68e5d"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "662987f6a4fc30c30f76b02af722223357ab8375f944d37633c5266e00044e41"
    sha256               arm64_sequoia: "c72cc1e58eeac6fe088826b673f68a76d5582f29aca4ea03aace7bb89a64e2be"
    sha256               arm64_sonoma:  "6c2f703ed33d7075343305eb7881c4524fa59faabe8cdc7c2340aa7d7ba91f8e"
    sha256               sonoma:        "eaad2e7fcbdff9fab179c2a78d89f9a4bddfa55b735bf48e8caac7fa6e0ba547"
    sha256 cellar: :any, arm64_linux:   "1bf3f9ffbd124b5ef35d883fe92c8bcf1aeff7e3e995349d91f888f0a012a9bf"
    sha256 cellar: :any, x86_64_linux:  "f7e01cbbae2c47fc847ea818abe5a8a5bfa097fb02a0fa82846e9e3795cff678"
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
