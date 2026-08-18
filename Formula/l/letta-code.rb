class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.25.tgz"
  sha256 "d644cba8203d35acf65af5a1d5b163038e0282004bfe57329e6520036b883052"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "72c5c8bf71adaa6f34a3686b77b5b0cfffe65fc4291dbf0a022470ada94210a9"
    sha256               arm64_sequoia: "f751f631cd8f3ec4fca973669f698dce7a7134a6500006715d55b4d2c134b9ca"
    sha256               arm64_sonoma:  "c7a2dc48a4256c015912dbc51b5996aff5d93c18488b56b6dab51399435852d4"
    sha256               sonoma:        "7f788e4962482bd897fc456237723dae00483bf7bf9391f6c70ea5c41570acde"
    sha256 cellar: :any, arm64_linux:   "06e89927f8705efb40086ad596f01e7eaa50d6ec564ead3d0617e4b57f2c04e5"
    sha256 cellar: :any, x86_64_linux:  "fd0d09ed9c84e84f443ac72a60a20a17030abc6ad63f7b9a0f2adb918b605dfe"
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
