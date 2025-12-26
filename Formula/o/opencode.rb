class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.203.tgz"
  sha256 "b65c161d9321e787b55bcdcb9d5d7b1c7f9305bd86964464864648f35daafa3c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "81c7bacb46eaa7b3cdcfa2a2ffbf2d85f764f75d7ca5b5a15ff764cf03d8910c"
    sha256                               arm64_sequoia: "81c7bacb46eaa7b3cdcfa2a2ffbf2d85f764f75d7ca5b5a15ff764cf03d8910c"
    sha256                               arm64_sonoma:  "81c7bacb46eaa7b3cdcfa2a2ffbf2d85f764f75d7ca5b5a15ff764cf03d8910c"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b86695e8daf5a25b0b5825132081d64c816c3b8f858ff433a8c3ce0711c535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40b9d2ab965fffb07414efee8c68617114697f2bb501809d16eda770566369a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632ead7e1686fd8fd1438a9870c412b0b9e9c623ecd3ae81235318d798919697"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
