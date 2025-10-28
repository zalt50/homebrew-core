class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.19.tgz"
  sha256 "2ea12fe352c6babe9a99d1697716dd64bce770df26a805834c723794b1fdbf06"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8875f89b208e9e99e3a68207ee2e6073ffee2c1b2a60423563c104539c97982b"
    sha256                               arm64_sequoia: "8875f89b208e9e99e3a68207ee2e6073ffee2c1b2a60423563c104539c97982b"
    sha256                               arm64_sonoma:  "8875f89b208e9e99e3a68207ee2e6073ffee2c1b2a60423563c104539c97982b"
    sha256 cellar: :any_skip_relocation, sonoma:        "56e60c72f64a3904b6aec024f720971644b41d419f8ce9b05f7ff36a6fa3bc4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e9ea685e2e34acfe2907091a2aff9085802437d095b33162fa74cefe3ebe440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d279f7742acff0e75b9299a2c9e4a95896c82dd59c574d4d06ebe1d84f6e24e2"
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
