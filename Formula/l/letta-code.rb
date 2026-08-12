class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.16.tgz"
  sha256 "f0f0088cdf9da24a54439318caa35399810f6161349543fdbeee06e8efef817b"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9008a581d794d9f7af6ba3e0c3912779adbba25963133f93be85c14296cff210"
    sha256               arm64_sequoia: "80953e268770b446c00352291e62f38e4532ea8771d9e20e759729a5f0af9112"
    sha256               arm64_sonoma:  "04369a645546fca3aebd4ebcb352ef10fa74dcd83618ce7c5b0cc378e98d4d6d"
    sha256               sonoma:        "fb0b1cf56808472c652263a44c65bdfe5e9c9abde6a8afa443241b67b450aad7"
    sha256 cellar: :any, arm64_linux:   "5397241f478c5b0ac3e4270069c7feaa3fe79897424a8148d765c47fd31ffacf"
    sha256 cellar: :any, x86_64_linux:  "a951054c59821665162546d7623346ba6cbb6d46f2fe52ad534fe6143ba803fe"
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
