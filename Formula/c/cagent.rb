class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "04c8b5b250c66ad6ea653de4d6f13f71aab982058920740d57ad709ad21ec292"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "606844dc0dc9482c08e5432238d5aabb994ce9afb55ac1baaac93877ed476d77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84cda2945ceba3c29ec3213f74730e299c112420856d7df8e1b3383e6e028222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ef9cc849af531c846a492ca1dfcc175a24a944253ef20b5be962a4a4a8c2e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8d3d62e0df39efe902fe2fe0cc5f6931d4d6759fe2f1af9d6a350ee3dcf8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86b67a59f55dc72b374ab6b0cf8da67f3003cf4faa540a110b4b7d9fea0fa2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace09e3d58b68ead84192880a422512304a4fffbc49d16a77c2782164e4c6473"
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
