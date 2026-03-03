class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "47e894dd5bdcd850d4806da7babac8235a4fbfeae725e4a255720cf486fdc4a0"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "391f3f3fdd50987d98612c634e371e1009e93f3d6d897fdd72d6e7a0efafbae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191720b8b336e67952ce4556ae1d66ad7338df5b42342e3b6c014294a905627d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e617500a725ef417f9f577825b2d70ce6015ab8397f8da0b26e7dea6cf13e254"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5dac61983d25c05ee25e73be11c616ce92fa87c06251358da80f6246f483711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030d4b88390cf88b26e123ff10902e04816fb914cc67fd2d030260ebb7d7fcee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e02cec02be62b80dba67d0a16d725d6ac7a5016cbc2a111b142193ba21f22b6"
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

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "UNAUTHORIZED: authentication required",
      shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
  end
end
