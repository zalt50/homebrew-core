class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.76.1",
    revision: "a5c35285577ddb62d5e30b53196f39d39e759c64"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88bf01ee0eb9744419bb89c4fc281034a9bd43ee861e1e171dc8936b8941f610"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88bf01ee0eb9744419bb89c4fc281034a9bd43ee861e1e171dc8936b8941f610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88bf01ee0eb9744419bb89c4fc281034a9bd43ee861e1e171dc8936b8941f610"
    sha256 cellar: :any_skip_relocation, sonoma:        "def6f2250ecf0be5904ceae17a3254feea1fdc5b2c7f6bf63e9d9ad1ca7e93e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7ff8a527e8d0ae4400829d1f8168fe51a32978be1f0cacfd0bb87fab944963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7c036fb1adc03bedc9d3d7c5f050ae484d5d61743171c52e3eb03a16221306"
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
