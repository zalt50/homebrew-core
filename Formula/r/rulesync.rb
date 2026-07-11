class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.6.1.tgz"
  sha256 "6004c66d0dc80f05e3227a8d3d2c601fdc566dab23dd29f250f673688c586257"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6b468bcad50c438da9a3a00d1a27bd5450237e4180424c137736e5183486a1d"
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
