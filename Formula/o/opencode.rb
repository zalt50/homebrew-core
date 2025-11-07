class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.39.tgz"
  sha256 "f2f73c986f2b33e1efdea7088d1d82ab47ab146739c96d358bfc0cebc48acd8e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "bb4ac4e89fa9a147df0114dc6323c5e95ddda6454092ced8c923e67441dcdaf2"
    sha256                               arm64_sequoia: "bb4ac4e89fa9a147df0114dc6323c5e95ddda6454092ced8c923e67441dcdaf2"
    sha256                               arm64_sonoma:  "bb4ac4e89fa9a147df0114dc6323c5e95ddda6454092ced8c923e67441dcdaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f33d96922901c33a912e2aa541e5ff213a8dafe7bf1aa20de0b86d9c37482afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e1a013a24cb4911d8803a5ff2eca68af47c61de18cda8b09613483d5ee3ac18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6688992dbaf19d6d323cfc0c1b28231642fd27ec0dee6542a941b07b8e375877"
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
