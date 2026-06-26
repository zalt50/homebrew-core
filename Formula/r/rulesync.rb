class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.32.0.tgz"
  sha256 "33d72e9e1d11490595354db424983cd70edec8d6443d76784d518c6588341a99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3281074da9ac018c7e4e9bd058b6c3e4833526947d1c8ec7621dd389f2d2d23f"
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
