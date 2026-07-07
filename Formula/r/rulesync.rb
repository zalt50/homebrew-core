class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.2.0.tgz"
  sha256 "680255d6ef863ddd3505c1f26bfe3f16b2eac8a867f7b56956656c0029d0ef8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a7bbe43cae28efa61b35eef68d89f71fca64e940ed0244a3477ae442b0ac02b"
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
