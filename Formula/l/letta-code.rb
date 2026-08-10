class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.15.tgz"
  sha256 "afaa200527aacd323e01e2600c8b8639281d15e398a11b7210904526345822bc"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "a23dfae3cf53a231c28fa22af5454ecaca0c0fa42f6e5df6476d2e70e07f0d54"
    sha256               arm64_sequoia: "2a61d16167265305b47ea6c5d383ddca60e060c4f1a3c235145e298003f33184"
    sha256               arm64_sonoma:  "3874a8ad1fd78d0e3b262c8c284c1855fbe2a0f122790c2c66be328e5e3e60ea"
    sha256               sonoma:        "4953b29fefc1a3e85039d5f9951eac68769d5ee80e6ec36f83e682933e022dd0"
    sha256 cellar: :any, arm64_linux:   "18a10b2755d0b0c5fbbabce62d6270a0d54c3615f4ce769b5b91d5d41effd368"
    sha256 cellar: :any, x86_64_linux:  "f5bd9ef4cb0486fe3e5d91fa3b47bcc70f32cb20684620cea0d0e632cd1f78ba"
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
