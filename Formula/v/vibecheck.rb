class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "2d0e13a1adc8511c4d12145bb4b7d006bd1af2a66f41044b4b89e37f1caea889"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e847b1d8843ec2affa176576d7c66fbedc961f8a67a97ea678f8850e43ab4d5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e847b1d8843ec2affa176576d7c66fbedc961f8a67a97ea678f8850e43ab4d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e847b1d8843ec2affa176576d7c66fbedc961f8a67a97ea678f8850e43ab4d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c04048dd848fc03713350aba34f4ab7badb7eed7d3e205376ae4277e70aed1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb1f66d909ba50b45d0310fa8db6e62ec6d443ef8d5520ab06980581915bf9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07aa29d75540113dadd64a02cf033f06fd0b1822e62539340d7309bb8d7ce0da"
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
