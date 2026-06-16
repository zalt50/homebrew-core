class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.81.1.tar.gz"
  sha256 "21dbeb4bf067e174a7a5fedf6e97769783b2d08b5df3f364a972ea37843d7f93"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7280cc02c4f11b545f06c08da19ed2083695e061be5d949b02acbce51f819d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e484e2b130fa13266556008a43903dba6b644bbde2f35806fb079e1a8a77f482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e261feabd224d42a3aa57f86b32eefdd5bec34cc587e1e26560312db6af0d85"
    sha256 cellar: :any_skip_relocation, sonoma:        "8505b44d2da264976054b66a5281200e192b18d14539c7dbf006065f3765dc82"
    sha256 cellar: :any,                 arm64_linux:   "da620fd4723412d2ea41b75969136f44ab249eed02b30109ac71dff1dfb6aafd"
    sha256 cellar: :any,                 x86_64_linux:  "a2a298b78a1ec99466e2765a7a04534a130263d28bc058c0dcaf18c3817c9a13"
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
