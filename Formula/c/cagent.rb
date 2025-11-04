class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "0abb3cd2e75d40ad47e21c792eeaf7394a6fe758321b4b9cff15fbfd31453a88"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f53fbf25089be288bf28ac8b995f7cd70a98bb812cac5d9bdcec7f38cef243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f53fbf25089be288bf28ac8b995f7cd70a98bb812cac5d9bdcec7f38cef243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f53fbf25089be288bf28ac8b995f7cd70a98bb812cac5d9bdcec7f38cef243"
    sha256 cellar: :any_skip_relocation, sonoma:        "394c59afa2409c63a002a6d465096cff17a6d8fa7a4d9706c3cbc9007a3acd59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee33a29d94372fe5a7937594ba7aa5f559cc882cdc28bbd3642f20bbd01312d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0039710cf8fa3bc372479e0da3b6db1caf0007aeb5834402aba41acab9f9bb5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end
