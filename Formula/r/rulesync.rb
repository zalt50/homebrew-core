class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.24.0.tgz"
  sha256 "76a6c904428f0fe5f53c68bee4d15a9dbbd71ad36d2875aeae2b0f0079cc84ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18a6c83f68cffd80a338669aba502ed5938c41e2a50ecc14369dfec00688f44a"
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
