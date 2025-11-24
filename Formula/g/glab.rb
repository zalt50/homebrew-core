class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.78.2",
    revision: "ee06e5192f705b7d656632f8fc8b8d04f61e5d33"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01130a433b72436348d836eef6c0b2af4b052ca4f096d55d50e35082815097c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c01130a433b72436348d836eef6c0b2af4b052ca4f096d55d50e35082815097c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c01130a433b72436348d836eef6c0b2af4b052ca4f096d55d50e35082815097c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aec887a926ca2d78d371b62db686d32ef27425d69f1bd5d22289ede4739a8a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6eefa83eded1202042c545f3fa7539e48f8ce3626207febf7d626b70b13ec4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195ead185a09525ea22b672d2542eb7bbcd60793e02591256ad6d241153e4a52"
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
