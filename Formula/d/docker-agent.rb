class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "4faf3d6008b4e27d0b6a333a7101c4dee33c375a97c40d4731332665d48bda88"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73c2ac08e56a3f41a4d9202c06df436b2053b979c0d5526af5ff728715324e16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492d5b88fee7873bd0a4bc7349b4cc060f09089cf536eb80ba497da240626c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2b64569d2db7128734bb45ba941633c6a2014b46a9b63ed4a475ba66300f8c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d762f40da371407bcd79f785cfac9fe2477c3198297eb77237da2cf90e5353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bb8697b636952c0dc82bd9d4c3c7bb4d9357d44553fc10fcfdf74275e98c238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9f6229b790ec7cca018ede9940db7de766f022c610979d805e590459c4ed76"
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
