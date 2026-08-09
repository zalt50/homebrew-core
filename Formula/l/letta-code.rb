class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.11.tgz"
  sha256 "2f9c7e40f687cee951c5c0f77e1283b62c8de59d8b37d00bd92b6aca5600072e"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9044296ada8aa2355beb2d1d27b0e97bf38fdb09966bdfa38023f6fcf79132db"
    sha256               arm64_sequoia: "7303e7b430112b8cd39821950b7b70d8e573a3753c3ff1be6be44fde2b6403e8"
    sha256               arm64_sonoma:  "4201fea122de08f79cb0287496270352cfed3986e9f56a18a9d2250a4ae536d2"
    sha256               sonoma:        "0a7943d713c9a5f770accb857444a1681a1a01d3e04edde2888051181d410936"
    sha256 cellar: :any, arm64_linux:   "a81a29e8131d26f7c1e862a83a7fb4d68ee3b6b6f62aa0ee1657ffd86e6e44fb"
    sha256 cellar: :any, x86_64_linux:  "843fb5ad97be676ac1d03575abbef37954fb69255dd2f6b7b59db8e71fdb4c21"
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
