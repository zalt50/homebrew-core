class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.6.tgz"
  sha256 "310754a1069de1e5481d89845fefa7bbc10577e6f7dc8870f48a0799944ba253"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "1b28fcf7554123418bc52042388ac4098774330efc37eaacb99078ad25d904d5"
    sha256               arm64_sequoia: "e21f5dac7b89c8c7342f16dfaee497f89a624586164cae3353f63009f0ce1813"
    sha256               arm64_sonoma:  "354912a74170d77a64f1110fbc03a2df62d6dbc57cec5a7642808de54a2c1187"
    sha256               sonoma:        "9e55ad47d12edf7d7e908080a96df3e6952237ac83cd588cd08534ec6a56a478"
    sha256 cellar: :any, arm64_linux:   "544e0da815220c3236f6d09e84ed1a51fed0dab7d1b876f23f50aae7d8270c83"
    sha256 cellar: :any, x86_64_linux:  "0e2515eb553fba197dc1d1965d2b57e619d068f98237eb206ac43b0e1747f3bd"
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
