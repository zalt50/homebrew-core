class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.2.0.tgz"
  sha256 "b5fac945997df2328a5e1f30c1590a77a2954e97f7a470e70991ebfcdb1b5246"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c19d4fe74303d2ec77f3899e517a4de908ad4a76f91489c7ffb47865e70c390"
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
