class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.29.tar.gz"
  sha256 "bb0f61a71f4609c8c53e4637032828d573e43c203edc4771cc417d28644f6936"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "046b23af75fa74e566d11166549838f898d5ea1367e46c78b4c6225f56339807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046b23af75fa74e566d11166549838f898d5ea1367e46c78b4c6225f56339807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046b23af75fa74e566d11166549838f898d5ea1367e46c78b4c6225f56339807"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c6b8166986e7591bdf0db726d38cdf1f68a20e08cc38dd936efa90c2928ef57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66f5b04495346517c5868b1472940a010562e47f7306ce8cc8cf2f3717cc9844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d17e68abb6b8e3a4075f573358c1b36d008b33e19c767a1f65291b9a8279c70"
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
