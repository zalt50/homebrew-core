class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.17.tar.gz"
  sha256 "2778c0676b80129f4a9319b517b804d03f67def92aaf522b934946c26fef9dfa"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1ba5ee76640478b82e2dbf84df4ef3591fb92b01981313b350d000db99c45d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ba5ee76640478b82e2dbf84df4ef3591fb92b01981313b350d000db99c45d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1ba5ee76640478b82e2dbf84df4ef3591fb92b01981313b350d000db99c45d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad9c2e594e49b6090440221e25e55b9a9b0b9540431cc24eb76d9fe3d05ebeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dddb7d11342a744e2d7bc61647fb3c3cbdb225886fc4cc45feb40bbf4e3dcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0635c2aad6d93f8a399834d8435d37e8c0e4afc9ecd641e8a1c0b58e72258da4"
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
