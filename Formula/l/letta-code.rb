class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.17.tgz"
  sha256 "6c2e1cd20a64dddec3712ced5083e61114f34ebb97cf5bf61353757aa8a28f3f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "2ec8c20289b8fb1ee640f88fec89746ac942665822d59efbb8851a28cb99ffc1"
    sha256               arm64_sequoia: "2c76cb32d63cccd9e9a3f04c18c66ba73cde5aaafe0f5599b98e64fea76250be"
    sha256               arm64_sonoma:  "0bfc2a8b5b0b1138064ec3daa726f9e8fe192e809b78efe5f264a21d18494637"
    sha256               sonoma:        "a44a9979344c186542b00b2a81a329e6b8f4a6ba375decf97ced8b767f5f7cef"
    sha256 cellar: :any, arm64_linux:   "bdbfa3ee15d2f8418a10b196b6b6351d7e64845f3ecc2e4cdea3a5064ffe4332"
    sha256 cellar: :any, x86_64_linux:  "13d19a4cde70b149787af74c4f7889cdc3fa394d9e5702f25da32be4800bda09"
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
