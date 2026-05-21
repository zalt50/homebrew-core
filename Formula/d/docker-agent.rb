class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "5e7c23d0692906cc0df66501da3880f25b30ed93148f5b7658b1ab100a232282"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e67374f17c4e04b1640fc822f6c56a3f5237edc8177dde28c2c3ac8d408ce76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdfc9ef8d87054a095a8b0914ae8d361daac326131c63e88d213e57178457545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844d46507220e7b37065e68d1ac09e65688945eae92c71fc518a41a98f84954b"
    sha256 cellar: :any_skip_relocation, sonoma:        "86d29c6182c0d7de92f5a8395fe48b29a8605e4802d72944048e80d709b8b88c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439b78378cfc11bd9d425f765f8d2d907b1ae9bbd3e3dc09c0d4d53098c66237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7dab3fae3ac579fa538dd9736901e1630872ab66b28dce0ebe5d5a111e70d05"
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
