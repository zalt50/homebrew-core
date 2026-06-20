class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.12.tgz"
  sha256 "a2e08a507c9bf3fd1a77e9d81acc5f88035a806eb5ee5aed1cdd332c4321d8a4"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "09ecf913995b1f616f07f2a3bea19d9f0644990dba6f052382f876c8edd49cd3"
    sha256               arm64_sequoia: "1c7f73f1e1e84ab0176f16b43b83478fe17f8fe1c999f6e5baa19c6339e52571"
    sha256               arm64_sonoma:  "bd4768e6b150a13de64a1122e5a0c60f2df0f9c9bfe6cc14b40881be506a83c3"
    sha256               sonoma:        "cb062e7805f7e0151a12871da3c641cdd528f39926feac7260ba51f258433c60"
    sha256 cellar: :any, arm64_linux:   "624f65487a3cede66e200fe4bc5d273dea24497318eace6cca0c64529029a479"
    sha256 cellar: :any, x86_64_linux:  "d2945c01b49fb7890e2b077c5def93fe62a671441560b4f7495acaf22d9c53b6"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"

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
