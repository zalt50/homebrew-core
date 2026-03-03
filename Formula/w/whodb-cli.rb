class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.97.0.tar.gz"
  sha256 "92aca6b9ac4e1fb333ee046e2b26f6a33c06ad23c243eac65144ed2b527bf2dc"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d6f4b89e0b00f713587e053e6609e3e02d3b982c3e9e52f511ebad1fd56e80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4acc53bfc3ad481c79af57fef59e111d630dab0b05d530dce038cf9f553250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a54292d7b8530d3be327b8b65e187757875383217825b917f9dde0c95858b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0d22a4cc2388f8e154a06068a4879b2d7d6940bc870b2ed455e4777ba1dbb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2bbea46d4d44ee88a39f771884599a97eab5c6e16126bf440ac94236ee46f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ffb30f3b91c17b04ed4d31549b08323c05d3b21c73419ed57e5475b86fec0ae"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -s -w
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"whodb-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
