class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.12.tgz"
  sha256 "ff2c757410140764f2c054827e58c41b5d37398ce09ff7ce9227677cd43d17ef"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "cd1e282deeca41e028eafa729d99c2e4b51d85cc784375ce4553efe627097d59"
    sha256               arm64_sequoia: "ab19f2ae4493ea401ddd4bcb71633fd43f2f9f4bad5f30d644f4741735d1903e"
    sha256               arm64_sonoma:  "5589d7e4196152398bb981da0918747d0bc7a4fd1fcd84f8ec4d08587d611048"
    sha256               sonoma:        "ae3178ae756a396373f815bec2c4b1237f454a7f0b3d3492d9d0031453fafdbc"
    sha256 cellar: :any, arm64_linux:   "8a25f18d5512da06ac98f3a9deee509f890194cc1869d02b13b573d4ea4f1a76"
    sha256 cellar: :any, x86_64_linux:  "a1e723532de7051d03b3a975642bc674fcb87741116f0e705b0251f02f4cfc4d"
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
