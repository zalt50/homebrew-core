class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "5f8c6126647d18d61b1ca33ae35ae741c23de4f504f5b93207c4347fdc9fcf41"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80e3d1635f98c2f8707a6b049d3a39d8b379ad34a20d72c19434b745c420a433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e3d1635f98c2f8707a6b049d3a39d8b379ad34a20d72c19434b745c420a433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e3d1635f98c2f8707a6b049d3a39d8b379ad34a20d72c19434b745c420a433"
    sha256 cellar: :any_skip_relocation, sonoma:        "49078092ae2a8d8462779fbe5bcc0dc4cad387d490324916b789b382c2f23684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ab0f7d9477251e64a98c01ca22cf8833f468766a7fed0f0dbdeffdf225b74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db75e80372148a830d17fddae73662ee9ab9c8683e43cd4aec97a217419ff279"
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
