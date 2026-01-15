class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.29.0.tgz"
  sha256 "060fabc860ec2ae0e07c6bf66a58f6f16b68f6a86e3a42d62fa9b4d3876d5daf"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a978d9ef12b1ddbe47be2c22d00c98eed20590eb65acc3c822c45356a883b53f"
    sha256                               arm64_sequoia: "a978d9ef12b1ddbe47be2c22d00c98eed20590eb65acc3c822c45356a883b53f"
    sha256                               arm64_sonoma:  "a978d9ef12b1ddbe47be2c22d00c98eed20590eb65acc3c822c45356a883b53f"
    sha256 cellar: :any_skip_relocation, sonoma:        "35860e9c5efc3acf8757ccd9c05c5d6fd55a9b30cf08de28da4af0db460cfceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bca711e9d1d73be6b4750814a0b1330a682df7bf432dea94d28ded1a3ae1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a92a9365057fae397f991bdf77dc61d6ffd74897f15608749a69014ceaea01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
