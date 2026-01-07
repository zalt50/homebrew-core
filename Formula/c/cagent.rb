class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "949097ea71f6fe49ca166ba7898269916f24ed5e4fea4313164962bf711b1004"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d66414276b2672c83152ce9f549de3aa44606839997249cf1eada2ef5b42edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c22524b164d8079e0e881c9a34d9bfa3b1d5eba48160365f965aa30cc7184deb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9362f2ce20872a2c010d126125adde3c94826252bb360c9be3ce2cb0c2ef0a90"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f4abe680ded8ee063fff1baf5b0a0d6f0e5e879cb1f45a6c6b709cd1ff87b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98e83e3e89944ac17d8d80c95581192fb4b1a50a664ae6e4f0e6985690d255bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1935c4371b1559b6647a4df501e831d814ef81d98af658546555ec89afb05071"
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
