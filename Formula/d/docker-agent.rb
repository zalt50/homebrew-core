class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.112.0.tar.gz"
  sha256 "d3e96705a65683f39e88f1a4b5fe8771243f3be92e1a0c3235216ed28b2a86a6"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "860d6594c65bf48b1f2515e098c00159701e517f9285c79c7b74ad03d6af88ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b36e1a246b2f453b6198f7e17e981d032636f6833ff8a1eceabb3eb6a9d977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa960717dacdbb21dc5ac8c1a8c143e1ed5586e76ade65040db8e24dba5b0d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e1acd785f32c603b3fdf683d8cc98f960fa8868efcee90ff3cad42a4e1a0ba"
    sha256 cellar: :any,                 arm64_linux:   "23c7fb6a775770b10ab33e650f03ddbb2683a51a6cb87fd2ebdfae6fcd8f9c77"
    sha256 cellar: :any,                 x86_64_linux:  "e5d0fdea4ea67e1e12cea76d789c7a8c8e678b3ba5d384a2351c25b2b5f2f048"
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
