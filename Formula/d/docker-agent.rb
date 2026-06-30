class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.92.0.tar.gz"
  sha256 "adad6039aa584582c76aed1e41c8e9c80e45d1354dfc1b209d58e7cba9a52227"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a94da3e6d05c9867c0661d98a9095c5176ba31b67cc93ba59bca921b9b14c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495ba0320ada279ad7eadcb03ce6fbb5b460c91b195074d3b4260e40c4c7aa38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81867d2c0415c4c776ba3df9adae966f8cbdaae30ca0d95dd2a7b044918d5629"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bef69ffd17e675af3fdfaab8876b2f515b1704e2991e007737e92328cec8df4"
    sha256 cellar: :any,                 arm64_linux:   "95dbef72e500e58d7d62c2dcec6ba825152c894f31be66f63cf142668dc5902d"
    sha256 cellar: :any,                 x86_64_linux:  "21e29e473e912432c7f8be7cf505ac92fc313e2e0c39ab202226459162e2dd62"
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
