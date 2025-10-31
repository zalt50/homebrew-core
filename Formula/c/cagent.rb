class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "3c3403f0571844b66aaccb597d3b5f715edf9099dd3b3b0302e6ed61be658683"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748c4817cf9d7917e6db2242b6b3b9cbddadc516e05588124ddf5045eedd8f8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "748c4817cf9d7917e6db2242b6b3b9cbddadc516e05588124ddf5045eedd8f8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748c4817cf9d7917e6db2242b6b3b9cbddadc516e05588124ddf5045eedd8f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "af18ec02cd044a41950ee7c2e285a104acb51f4f621423467c5c75149bcddeaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfb9a2bb0ba5abd3884c7e178b345f149e7a54f62e3fd9246e8740fc06e63230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11dfeee6ab332be81b99af6361e97cb4499f291800f8e95aa52d089dde876e5e"
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
