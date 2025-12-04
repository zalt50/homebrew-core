class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-13.1.1.tgz"
  sha256 "b374ccb2a737166cf623d53e9c2fc146055bb59eb318283df0493bd35839ce6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6ad2c7f2925920337c707b9ebeaeb5f75e8329864a9ca1893df6dfa327488a1"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
