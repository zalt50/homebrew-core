class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "5f8c6126647d18d61b1ca33ae35ae741c23de4f504f5b93207c4347fdc9fcf41"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0e736f657725127934daa51bbe3f2fb1105f0abd5b7535b7c7647ac28d7d3fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e736f657725127934daa51bbe3f2fb1105f0abd5b7535b7c7647ac28d7d3fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e736f657725127934daa51bbe3f2fb1105f0abd5b7535b7c7647ac28d7d3fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c580f3428ceeae4ba55ffe9ba8f0b024d6cc735f0bc7958992e930b535dbd48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af712b1d07b626fad09d0203ffdb2284b45637457b331200818247ed3b14bebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81bab97fe6dc864aa1d32dcbdbea83998b672624a3b96b6304e7d73688de22c0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end
