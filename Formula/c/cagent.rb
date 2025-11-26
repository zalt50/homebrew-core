class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.26.tar.gz"
  sha256 "0dbe61672588b268b0009d1e99224445b55576e630828abef5b378cef2d69b93"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d8a5eb0d0cef7f343c53e7ae54fc0166bf59936c83fd1fec46e95e363dceb99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d8a5eb0d0cef7f343c53e7ae54fc0166bf59936c83fd1fec46e95e363dceb99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d8a5eb0d0cef7f343c53e7ae54fc0166bf59936c83fd1fec46e95e363dceb99"
    sha256 cellar: :any_skip_relocation, sonoma:        "0984237ddada9328f64dce14108eb3aab087ab695dddc46ab487ea64da3a6a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f9a20d63b717ed05fffd5448ce8211f27186257f9d9bb03830808bb92e9198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a27c16a05a106a52793dc8330491c5dfadf572aa9cc7ad08dd3ba26edc0141"
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
