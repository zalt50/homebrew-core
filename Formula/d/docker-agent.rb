class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "c13a1ebac7d42761820ed8171cd0b732c57d1f5d5e802de6b254dd2e6b837e88"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28cbff0e73c09e844c10721f5dc9a1a477d1f0f49c64817517ebca96b3adc1eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d76711c3281ff01aea810c8ca90665b91abd18c837b0a1e6bc481e144d06d0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "928f9226bbcb7b4c6379169c2c25f3d291cf4f58204c555c3fa8a714bf7c01be"
    sha256 cellar: :any_skip_relocation, sonoma:        "480bab3c5dc51762b00297144ca86dd7905c8b689c8f4c5ac2c1c822a997ffe0"
    sha256 cellar: :any,                 arm64_linux:   "c4433ffaefd92c4290241c930e9982dba1c2fff1652699ef7a620cbbebc0d203"
    sha256 cellar: :any,                 x86_64_linux:  "8ba2b4ee0efb9aee4d0d691938ad8a284347792fd4e1fd89abab57eec3a25eda"
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
