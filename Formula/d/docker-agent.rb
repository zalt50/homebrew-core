class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "f546912916315943f7eda467e1d2c31a40991968f66792e7d83294d5ebd197b2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bffebe8d5133a4f119c5de43c0267bd84d4df1cef471b043fff329031e492b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b39653cddcf35c864dd0237b229a148116a509462d82ac913f26319dec83482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cdc56ede42e1c16eab4dc0bbc465dea4216fae6a9d99720199bc71b8b1e3dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5b8ea8c535234a75024532cfd156d3a962f7c43d288f7f61ce0c644301b49ce"
    sha256 cellar: :any,                 arm64_linux:   "70d0d010427ab3c734e2fb9006a13926fe6489843b386e027a9ce0a725667710"
    sha256 cellar: :any,                 x86_64_linux:  "4ec1b2bf3a7923666fb89d5eb3e87071ae473dadef91b5a9460acb7fe0644ccd"
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
