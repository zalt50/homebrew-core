class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.4.tgz"
  sha256 "dd3abc036940f0439fbe58b0c1a2830b392e57914f45dc756be9265cd0d7c51a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "08586f966a054a668e7844740e68ec38e37cd9abb674f0541400ea605822d292"
    sha256                               arm64_sequoia: "08586f966a054a668e7844740e68ec38e37cd9abb674f0541400ea605822d292"
    sha256                               arm64_sonoma:  "08586f966a054a668e7844740e68ec38e37cd9abb674f0541400ea605822d292"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f6b7704d3067521abc426660c1e8ec73b5367528c44c16a14427c708e4117a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45bf6b3cec913bdead650a18679df622ca3f0cb838cb181edbf51643c0c66738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8e61663e38cc8973181eb038bf758d04e732bb65824aa4c5eddaf261b9ec4b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
