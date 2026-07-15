class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.108.0.tar.gz"
  sha256 "2ed1193cef7b8dbe898632258dd799fe9e3c8fee0fae71feae0fff41a62facb4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d57282bfab907b3d38e70c3b861b96a8bc7df3db7c76c10c28dbabd02d71e992"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4117fe7939ac13d8060f72cea684d85dba6e916e8bac3d2908fc2262e7eb2b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4797968689808b753b86b1181aa8cb7b420066f672e9a2eba1e8cb4bc49568e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec52bd8e2bd5b1748b7f31c6bba990afd7a0f12cd1fbda30a5476766d1af1d9e"
    sha256 cellar: :any,                 arm64_linux:   "83f98d388937efaab4a144ed6f599fa6dfb7405681d78a6ab4d56a8f7165e021"
    sha256 cellar: :any,                 x86_64_linux:  "883ae261058f30291521a754fa2b7821b569c69dd560698a107b3ad327f14787"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
