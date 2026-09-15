class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.32.0.tgz"
  sha256 "dd405e49ff55397be8cb3b16322fd0921078aa5c801b9f4600d5f4557264c1fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "710dbe7cf991436ea8cc665b2aaa140875f79a9e66f420069466486fd75b7b3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "710dbe7cf991436ea8cc665b2aaa140875f79a9e66f420069466486fd75b7b3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "710dbe7cf991436ea8cc665b2aaa140875f79a9e66f420069466486fd75b7b3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "450a1f1a44e29901c97879f1b24e6f53fd1f241cba78b58c4b10a67b909669e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "450a1f1a44e29901c97879f1b24e6f53fd1f241cba78b58c4b10a67b909669e7"
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
