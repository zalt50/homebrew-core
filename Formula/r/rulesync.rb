class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-14.0.0.tgz"
  sha256 "d419a773d4df01afe81769c7fc3e8ad04c30c8003347d1248c0eb2b24107cfaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a8c35364a3d6f06979646d7b8371a6889edd8ac74f78b0e95aa100e23d19290"
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
