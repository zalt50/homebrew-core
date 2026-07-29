class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.8.tgz"
  sha256 "26c6f398c69338dd52d8b9feef2765769704a4fb7cf02479f79036f25fd8f51c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "0d6742c59c73757ca516c7f11bf7e42637f5fb13709625e8cbdfd2daa277b864"
    sha256               arm64_sequoia: "ad74289ca4c70bc617f3d0376a98290908cfd0954801b11732be844f1e4918d0"
    sha256               arm64_sonoma:  "0143f86e7a2ea0e3eada9912e5c73d4407a09aafa41e16d1ebf4486e89b28713"
    sha256               sonoma:        "16f12289993f11de8c95a6398b3ee245cf2658dcf5a85f6c39ebbb195999cb3d"
    sha256 cellar: :any, arm64_linux:   "b2cca3943ba76e5a4bc6dd32b89ddcfe29f5d19854eaffd28701d3767e1c80d9"
    sha256 cellar: :any, x86_64_linux:  "b881031d1372fc4cd4bbeb2dd0b0b951c367f704475f5df1e5fec11b1a96d16e"
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
