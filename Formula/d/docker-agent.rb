class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "d907663ed45006fd2a0405f39647eccb900f8d0a90ecb9d3ddfa6e540259edf4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "597410e2a8d0d1ff819678e1aee694f611da63c7b16d2e4fdfbdfcd69fac92e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59449bc34dd6732017b29b558f43def55493045fa991c51ddf94fbee9b8f90b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce654e6516394f6ac6535b693673750a643174e20c9e4a2983dd20c4ffc34215"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dda033848d10c54db7e4beb1b728c1f70fa6f42148c8fe9aea4a0b77b8273a5"
    sha256 cellar: :any,                 arm64_linux:   "c7696f4ae8ba6f1edab456b20481642281b53ad1b9300e235be8c6309c0497e8"
    sha256 cellar: :any,                 x86_64_linux:  "15dab904968965b4acc98a607accdd70722ed7bfc3c02fd2b04404fd45385d03"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
