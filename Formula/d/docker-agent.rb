class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "f70c4b44da152bdd48d67af2f3be50e5e64779863a8413aaad350d379d60898a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "731641e41a8c52e86b75dfce59cee0e4e5dc0f0ba768d71c626213a1c61d1f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8bd1fe3c6af5196a45379dd5c8c1643f7f96e7f5801a6501f1719ea8bf322b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0cb0771a93de897c2ede4477b0358480e84f95be5abcb1ef41ddb5d2a9e9865"
    sha256 cellar: :any_skip_relocation, sonoma:        "c493e0e7ad3a7c10a4ba571d1efe109efa5f411aa768f9f5f6f6062fc54778b5"
    sha256 cellar: :any,                 arm64_linux:   "3d955edecdf1c15e0f7050bcbf2ed2e439136875391e31206e257391174167d9"
    sha256 cellar: :any,                 x86_64_linux:  "25c215b214f3b4b9e1c1444086861ec65e42ac62f15b6d3b727c616e903db72f"
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
