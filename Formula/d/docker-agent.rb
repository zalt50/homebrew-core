class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.100.0.tar.gz"
  sha256 "d19da40d0883d8a504575f3dd34ea3fbcb537f4fe5b93dd4cc765a0b3c464320"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24e13197ac6b8add9b650133a0a6fbe4d064b273636d0489640a1623b7747ef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aa60f22d74840b04f6b2128daeb38f2ccaa04d97d753fb3ff790514d47b43fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd13bf7885faafc67940506cdd728b1b563e37c09c9d4e8a2cedaa0e48c2b18c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5cc1308a3528f4fc599beae34182c2ab78accfd2079fac4e65a3a70d1d44f00"
    sha256 cellar: :any,                 arm64_linux:   "b76075b37138d0643facdc3861d99d34290c69a17f9dc7501cb55146e0d8f725"
    sha256 cellar: :any,                 x86_64_linux:  "e2c481c921f44f475a9aee828846d33b74cc9375e2d2bdb05e6abb2b65c11cdc"
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
