class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.2.tgz"
  sha256 "9d11c863d0b6cc479f0e0c63a0b7d05cde3bdabbd487a755ebbd43092fb15602"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9207fcb70079fe3adc4eaa70b819ef89500004a990c9bbc06e3cdb8da85cac26"
    sha256               arm64_sequoia: "a9c9d0bcb4d65a33da189adb3bcb14a49b941b50805032a2a8e5d5d3eaba8e8d"
    sha256               arm64_sonoma:  "99f0ccaabcc326c8c41224b5f0e84ae86214a3594249e9e53ca0acde1a76469f"
    sha256               sonoma:        "f491f99cc74ca7a182d8bb920080a247189c435b031705aa29fa15e4632d2886"
    sha256 cellar: :any, arm64_linux:   "ae8efbc64bcdd987d7eb6021ab8021fe476d4dac02e3d907526c03c665f952ee"
    sha256 cellar: :any, x86_64_linux:  "4648af4301a737c4a670a03c9e59ad91f579a21f67f5e5e28bc99e4082d7fb09"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"

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
