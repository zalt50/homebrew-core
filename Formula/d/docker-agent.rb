class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.70.1.tar.gz"
  sha256 "5815082a850003a52d78dea6ecf27241fa25c4703cf82b9100067daee31806ff"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3317ce4eff2d6501c6b4c2e6d20bafadbb6052e75fadff5eb3b7d9f233921ebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85887a86d26523d8aed221ff639d7b08955290b97862261bb2b39b596d6dd035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d70ac0a39c2c978f43e3cdd19305eeca781905f3748b966ab285104182cacdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e024883b3da8b5ee37b733cb020b5700e7151b32de6c7cae62e2198740b7b02"
    sha256 cellar: :any,                 arm64_linux:   "fd793c522b7c9a738de5f5da6f18408352aa11f3f4d4d60f9394702e7336faef"
    sha256 cellar: :any,                 x86_64_linux:  "cdee826759fb3c8c585f5f968375b45129c26f9ebd06666f2290a7b7d1805d31"
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
