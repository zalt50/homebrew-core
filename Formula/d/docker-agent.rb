class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.122.0.tar.gz"
  sha256 "87cfa6052e453dc3da79a4756aaa8856e94cfce7d08e736297a23df8d2c4aaa7"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4e5b844de8a5321becabcd58516dcd4a31b589927bebad877a82afcb31531df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90d233f5d5b13fbd0dd3d6b0a5fc8a007ded2ff983c7600fed6bf8459d94497c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a1478b986d74c8e5755dee81cd130bd15010fe489a7d24d04b000da3dce2df"
    sha256 cellar: :any_skip_relocation, sonoma:        "64cfd85e61c5dd3a006384c18acbfaee6a544cf301f3d40e5c61b9d8251f434c"
    sha256 cellar: :any,                 arm64_linux:   "00a51fe813ff41d72fb79d04722193eec6f84ff28fdb850112f5c8ea244b39af"
    sha256 cellar: :any,                 x86_64_linux:  "558c660079b2dab920238b10def18d20df552cb330521e027bd41d6653b0aea2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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
