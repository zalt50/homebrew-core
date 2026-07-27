class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.2.tgz"
  sha256 "d134825b70d118cc85c9d619442fee76176dfca0a9032faa3bd083879fa9d1d7"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6b2981a425e52ecf97627129f5ee7a6e2d085b8f45dbe50928e9fec37cf1c391"
    sha256               arm64_sequoia: "7bddefd4d7dbab622367df48e7a854e024dee3b8d2898f505606a7f569a62d6e"
    sha256               arm64_sonoma:  "e2ed753c2e830874c9c38cd2de18cb26eba84befba943058577ee19f68e8ef70"
    sha256               sonoma:        "9a8c8c87466ce50b06861367b09a18c188aee1b6f30e52e6ee1e3c03a4af436c"
    sha256 cellar: :any, arm64_linux:   "d94418d9face2fa436bb69cd50341e00702751195046dcacf011226c2c9c8c6d"
    sha256 cellar: :any, x86_64_linux:  "30d041089f697d9f1da72b28495974819ff75e2aba8e56095289679bddf022f1"
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
