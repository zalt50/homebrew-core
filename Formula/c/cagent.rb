class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "9fc65e07b23c45b9ccfc7b4d40accb2d76e4706eab3e632280401e6040465fb1"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de470758f0d08df011d9c16a68cbcd062eab0896403cad30f443526676f05771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "243b27e59f3702bdd5ea097225bbb8194b137611032304ca2ebfcb54978ed00d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a3b1fd0ea8976b939f1de6532aa26cc65f1e190c41f58a1e0ae60f0d672e2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f451e62d251fe3fb2e9d355a782603dec810337e73ffb018f23810870cfe5fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dcda862699feebb885f34d07bbb6e0b59ca301baa383d6a314cbc9c0cf71c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d918e3b49d86135ef67a273425a9eca7ecb3c070434b4914b455207661e2769c"
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
