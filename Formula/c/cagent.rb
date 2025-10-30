class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "8821df377653b2800936b662454463e2caa6f41c55747c26a7397611748ff299"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cab6179aeff69cce15ac1af223176571bc834a4dbf7ce597eec9401c259f33b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cab6179aeff69cce15ac1af223176571bc834a4dbf7ce597eec9401c259f33b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab6179aeff69cce15ac1af223176571bc834a4dbf7ce597eec9401c259f33b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0099be21b28714f29be90b0513dce392e583958a52a592bda00c133e06a1a6ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab1569c4f3cd03fbf805341b74a041e3e129f1f559dd07e42f7347f726be24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1caaac53eaedb1753efb14fbdbed7addf402829f6dd81ff453124769da4b2445"
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
