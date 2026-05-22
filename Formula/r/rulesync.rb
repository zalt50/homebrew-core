class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.19.0.tgz"
  sha256 "75c640a34344a834f2cd875284f4e9e22f591eb8d7f4634dbab587055feff49b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "faefb05fbefc76c80034e845cebbe18f4866fa582fa5132cb12605d9eb2e2f58"
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
