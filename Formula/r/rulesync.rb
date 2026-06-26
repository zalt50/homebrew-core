class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.32.0.tgz"
  sha256 "33d72e9e1d11490595354db424983cd70edec8d6443d76784d518c6588341a99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3aa456effb35c99583f5a4d6ad165f27ce98f500a5508744b456b033e8b3efc8"
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
