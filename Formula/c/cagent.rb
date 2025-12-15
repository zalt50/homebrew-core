class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "6b49184513511ad271102bb0159214e25367dc2ea5ccc71a752cbfdf99a4fe1f"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9520dbab40afb46aab8dc2175f1dfd1808041c3bea6a780d30a8fc35f8d1120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dcd76a955c45af48291812ba9a1ef04aac513d01f9dea8c2532d0192554d2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6894f9a39ca23fcb532379a7628c5fd3e25e786d515bd705d478774926ec8512"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf516bb879e69e73e44a6ddf5dced5d3ae5bf387bff22f4abd2aae229ce49c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6599240e08ef5e76c775bee1ba6dc791185dd73b0568f0181508a5b459286a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f4d4de6823bf8deaee2c4f0bd056ccbf641f3373eb13cf2b95635de174fb29"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
