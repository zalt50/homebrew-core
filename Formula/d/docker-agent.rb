class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.95.0.tar.gz"
  sha256 "e18529183dfcb6acb5778ad2f60c80ad6dc34e65e0f3f32f9f5483aea2e6715a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "624d9b3c0338e0d0cd2fc3b90c92988085ca21dbc5448d3bb600bfa7c26ed6aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e504be61fcba9cf8cda983996c20ecc70e4554d16d9eb910322883c9e026457f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "756a8276b0bdbe754a2be42ba4074ff481331e469bf6937872c1727d8b0d6b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3ab86b64d35390003f2de2b2c476dadeaaf3cc7c32fac849e84244e73499cf"
    sha256 cellar: :any,                 arm64_linux:   "70a9563b772ac620ff7eedebb003472290cb70af1066cda6a2116ffdceff16dd"
    sha256 cellar: :any,                 x86_64_linux:  "c980bc58e8fe569a270b7fdf67376e4dd961d100828ee1ba397486b35e3ebb05"
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
