class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.28.1.tgz"
  sha256 "385f2bfc1099138fcbfe3481d9a31f4df24b5fc5e94e430912e65ef2f1270ead"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1567c56491b464ab015f1e3d9219a8cfafaa697c27e182bff7e5127b14223b14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1567c56491b464ab015f1e3d9219a8cfafaa697c27e182bff7e5127b14223b14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1567c56491b464ab015f1e3d9219a8cfafaa697c27e182bff7e5127b14223b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26195109ab6ae106d5ceac58fe51ce68b458a456d2fb17b47bbdef84dd1766d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "26195109ab6ae106d5ceac58fe51ce68b458a456d2fb17b47bbdef84dd1766d2"
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
