class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.98.1",
    revision: "720b4cb3b4a7700dd6ee6205553aa3a5543f9034"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "891cf83941b58bfb274a9ab663de13531a41321489f3d6273716753903912e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891cf83941b58bfb274a9ab663de13531a41321489f3d6273716753903912e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "891cf83941b58bfb274a9ab663de13531a41321489f3d6273716753903912e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff538cdbe8d31c77dcac9e3e16f4b0fd2ed7996e370ecdc3abd7926ac326b6b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "146c804745832e5a42194c8a86fea2b9a5c679b3f1049b2714a46e5de3a03cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd01bfbb52a3d2c67170fe70671f44930a0b0d04d65025d85ecc3f00087b1af6"
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
