class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.91.0.tar.gz"
  sha256 "4eba286a0e867cba18001b7eeb4fe545d2e2834d823fff4626d25aeaf999db75"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43c01de0e4f30fca4c72b26c2316800387414a212e4c0bfb30e00228e669732c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f0ff49ee748790b134e938b243707c103dd507c8b62a4d153bad70dc2d7418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b3da8ef3088206dbe062677ffc7cb68caa7c082e5049fbfd36e61fd337b4877"
    sha256 cellar: :any_skip_relocation, sonoma:        "361d0be8d16279013c0285df29da418ee24a666725b06a8d9f2932a8e6ed760c"
    sha256 cellar: :any,                 arm64_linux:   "61edb9a6f61715c06cb250dcedf7dcd33f21e030395b4bd68b4468bc671b9f8c"
    sha256 cellar: :any,                 x86_64_linux:  "bfd5b8caaa424ee85b28e02879e0c7a73e407c8245f8f8bccd78cb83b50b82ca"
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
