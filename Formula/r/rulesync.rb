class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.7.0.tgz"
  sha256 "1a03d251969634623a21b460e20c109c45d27ac5a46c5b3b589e3b97f9d88780"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "325c19497fc30c95d9ea7e36a9a332dfb8aeb69c19f0737a35b2e1090d7dbb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325c19497fc30c95d9ea7e36a9a332dfb8aeb69c19f0737a35b2e1090d7dbb1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "325c19497fc30c95d9ea7e36a9a332dfb8aeb69c19f0737a35b2e1090d7dbb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bffcc167552d7288ad5ba7734a973481582819899b480f6525c61912039d301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bffcc167552d7288ad5ba7734a973481582819899b480f6525c61912039d301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bffcc167552d7288ad5ba7734a973481582819899b480f6525c61912039d301"
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
