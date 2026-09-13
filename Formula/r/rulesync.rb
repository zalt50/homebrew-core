class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.28.1.tgz"
  sha256 "385f2bfc1099138fcbfe3481d9a31f4df24b5fc5e94e430912e65ef2f1270ead"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a9d5f62e04f19022c398ee12c536057e31caaaaff22b1d023350a827ffc4c57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a9d5f62e04f19022c398ee12c536057e31caaaaff22b1d023350a827ffc4c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a9d5f62e04f19022c398ee12c536057e31caaaaff22b1d023350a827ffc4c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f17ab5c6f9783cd75aaf38d9add54ea5c8c0ef0fc8b7c65cf28da588a7fd29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f17ab5c6f9783cd75aaf38d9add54ea5c8c0ef0fc8b7c65cf28da588a7fd29f"
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
