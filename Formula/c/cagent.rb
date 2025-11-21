class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.19.tar.gz"
  sha256 "0836cfc47a9288191b7cf2eba52222faf28d98db70a9e2f9e7dd9afc7e85e0b7"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc41515305752ce8f105c903367beec1b8c644fa6fb0c761e6436a457978a1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc41515305752ce8f105c903367beec1b8c644fa6fb0c761e6436a457978a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc41515305752ce8f105c903367beec1b8c644fa6fb0c761e6436a457978a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "055b9ea4e1e5bc0b4c132dad11fd01d062d39a2c7a82aaa4f60582604e6e27ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "418cccc27cdfe4c46ba8b73b37edf300dd890bd2d2f1a3850cdfaa39e5db4326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e409d02fbc2a009cf6f6bdfd2301ae947364e341d2fd27b60a62050f2557e033"
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
