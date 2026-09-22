class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-17.0.0.tgz"
  sha256 "33b266c28be0cbcd0720ae1ebd636e0aab1238f4cbcc969f5b8e3f1541f5d9ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80c4070c78089a44ab4344c15632f004730ac19e24dcf106f8af114ece281285"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80c4070c78089a44ab4344c15632f004730ac19e24dcf106f8af114ece281285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80c4070c78089a44ab4344c15632f004730ac19e24dcf106f8af114ece281285"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf8719069dfc8cea24b3c4ff38006852099c2bb825832424a0def53e5ea938ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cf8719069dfc8cea24b3c4ff38006852099c2bb825832424a0def53e5ea938ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
