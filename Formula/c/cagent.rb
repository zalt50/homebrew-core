class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.15.tar.gz"
  sha256 "ffdbc156cdf6d0c230ec908cb69a34b15fbc9c7fc8b406a9db9f016849110a8e"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2521fc198dfc9fe6812326a84344dafe1dbb8d1829d3e109c7bb8206e0b61aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2521fc198dfc9fe6812326a84344dafe1dbb8d1829d3e109c7bb8206e0b61aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2521fc198dfc9fe6812326a84344dafe1dbb8d1829d3e109c7bb8206e0b61aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d065bbc6a9f5918afd21b7cf2d49b6b51e758132d9b48719aaa07a908b96248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a1906011b53a45c7cb26c92bf398d0e859b85ce971e6f06caafd77c76cbbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b90609dfb030a96ed56dd2572e803ebe4a264c0e07b3400ce8da92a56f9401b"
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
