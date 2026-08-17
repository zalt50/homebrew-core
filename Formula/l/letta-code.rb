class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.23.tgz"
  sha256 "5abbf774200b4e2605f27b9d938840e41d52a310d1d9dd8664e19292cac65c88"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "d4374ab308e4269fe41221a0c8214f6fc4ae38770b44c1c88c83bc55e73dcb70"
    sha256               arm64_sequoia: "a817c2ed2c238ae97605bc1fd573ce76f061fc0f6c0d39fff26e61390c7cbddc"
    sha256               arm64_sonoma:  "e23c3f0d4ec6c77f63915489e462736b3b50166b70a041c8ef8ee8dc970e9c35"
    sha256               sonoma:        "dd338fab9987109654d28e19bec60c8ad809ee2f9fc5dfd688dabce82b226a98"
    sha256 cellar: :any, arm64_linux:   "f6162f11842ad5c2f5d3f3fca8bcdeb4b88b3a5684f0cf52312322ba8cbd7fa9"
    sha256 cellar: :any, x86_64_linux:  "7cdac73df841c32e696065ffec3db2870354f6f8f96e60f67606a6de4ec1a6d9"
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
