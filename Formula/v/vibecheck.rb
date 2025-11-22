class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "86a54b1b4aa2a4aae87948c79f8553cb8965541fdf5911acae31119b172b3147"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb65f203d4f6122ebbd79cdd904180e716cbf6c2a26c885c0997d071616aa13b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb65f203d4f6122ebbd79cdd904180e716cbf6c2a26c885c0997d071616aa13b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb65f203d4f6122ebbd79cdd904180e716cbf6c2a26c885c0997d071616aa13b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb04b4fdbd8d392b295606915ac87f2690066a0885990b5b976eba3c4cc4f1e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c2eada0691a20c2f6987c2c5d82b257318f92c35764603819de5861365b3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c504eac6b3cba106e542910d67f59cbeb86e6ea9165c514722b5cba669370c06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end
