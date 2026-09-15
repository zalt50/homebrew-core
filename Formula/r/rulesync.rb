class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.32.0.tgz"
  sha256 "dd405e49ff55397be8cb3b16322fd0921078aa5c801b9f4600d5f4557264c1fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b7bd9873aced71b4f6a6525c4cd0c868e0cc60318469b50c6b9f2f90db25104"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b7bd9873aced71b4f6a6525c4cd0c868e0cc60318469b50c6b9f2f90db25104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b7bd9873aced71b4f6a6525c4cd0c868e0cc60318469b50c6b9f2f90db25104"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6463419c5753f3091007db46ac564ce2e81b406b961d3cfda291810dda5c8599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6463419c5753f3091007db46ac564ce2e81b406b961d3cfda291810dda5c8599"
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
