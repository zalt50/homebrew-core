class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.5.tgz"
  sha256 "928d29f0906b229e79ce5faf855a4c620734d8b50c3f720d408db01d692cc646"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "863f8aa9dc26bd6b0864aa55fc659351851ff37c8ae78542f61fcc2e90095aca"
    sha256               arm64_sequoia: "edbb483f1998e60aa161a76490541a60038e2817d08450b675be89e0e3a8e162"
    sha256               arm64_sonoma:  "ad4088bec276fba4c5bcd87bf4491b2bbc8a566fd457bfc0598c6ff5c209b0f1"
    sha256               sonoma:        "ca45d513dc409f7914d1fb5692b60ff19866c79030b615889f9e2c5d449aa10f"
    sha256 cellar: :any, arm64_linux:   "9abdc94efbbb8b6c3ff5f308e5061c7012d5c5306fbef1c7d4f746830a0336e0"
    sha256 cellar: :any, x86_64_linux:  "4367189262cec099bf46440b64756214aa6b8b7a8ed241a5dcd4997bd16ca40a"
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
