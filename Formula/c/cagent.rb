class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "47e894dd5bdcd850d4806da7babac8235a4fbfeae725e4a255720cf486fdc4a0"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2998ec658690a76a4d0c59a568b3fd6681490ec5608521c4a5874870205a182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8493be251282510563b362647fa740fa99c80a6795909e161961a0e17c19ac64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77ecca91aecb184cf87ce99d2756562f7366eb56a39486af8c1bda62245177e"
    sha256 cellar: :any_skip_relocation, sonoma:        "65f36ea1cef12dab7fe88d300dbf6893efa7deb610239d464523cf4ba5212df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d5803780315e3eae93dbc4f89f86e949fb138e58f481b0cea90363cd5f01e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab9709df9613916e7bdc70c7c1a9ce340ccb2146ed8dc809eb5b59ea45d969aa"
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
