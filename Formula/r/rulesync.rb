class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-10.1.0.tgz"
  sha256 "51144f98c5b44d70260a8a67132f0835c51fac8c3592ced2e6e0a7c2ffa1e8e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32988486b8a8d2cb0a2fa61c63fa91953dcf5764d65a2cb4252c7e18235aad42"
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
