class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "f7649ebd82d9f6e04e7d829a0150e6df62a91f3696306cee3be33aa1e88ea872"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6deb0469a5762cf866c63d3c9d2787ea9855c63141d8e9687094764bc280b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2452802fdc35ced350b5c664aeae0f8c5967faca89987604d89d75326db899cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98bd03152cf4afee9da9d95b147b6524409723147d5151fc564ee7361128ee90"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fff936e4a05aae6b2a9790348d7f7ce9c03cacc4965bd9faf551efd8f21443e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e424882fadd47efa857020b866df2114a01d524612aee45140cacc42b9ca3e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c1687ecacd41db996535953c2936889c001973e0a7e5b131be34e7d2219b66"
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

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
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
