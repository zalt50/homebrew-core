class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.101.0",
    revision: "b37860458a2c5f0ef8caf606ae5b8be30b0c62b5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5754f95686e6fe73f19a02d0e1558a008f8f449a266e65d201d066568706f3c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5754f95686e6fe73f19a02d0e1558a008f8f449a266e65d201d066568706f3c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5754f95686e6fe73f19a02d0e1558a008f8f449a266e65d201d066568706f3c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf0629e2528cfdf4f6383e7fac87db0e6774e3c4a79d02bbfe9d8e05b79d87a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6afc8c413b8e7deb8fbef064fedec506198d2a4395cfc9144867f436d9c0828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6b54631b9379ba68571b9ca5e7d0b0552be5d7c1ead97f4c0371455ca51a96"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
