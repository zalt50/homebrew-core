class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.129.0.tar.gz"
  sha256 "b2cada31f6c2b324585572b00099c7cee78cd1d57eadc2a04cd67dcf3cd3b046"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53e150e0b125babd9f399565e5eb448fc8d319f685c7198a43205cf14333b8ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c2861b9937f71f0ed5028445ceff8ec27583f32b564a0f0fa33fe3b78e3421d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d448761b7eb88aff901cb150fa79353e4624944ed6a42944a55d247b2ceff59"
    sha256 cellar: :any,                 arm64_linux:       "917df24676f2a08037a08b88c4e6276256db0443d9de1ffb8a2d38aa5e3150d9"
    sha256 cellar: :any,                 x86_64_linux:      "ca6e24894853cccb2c20859ac27f8864c622e5edb5e162589161581a74d82fe7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(output: bin/"whodb", ldflags:), "./cli"
    bin.install_symlink bin/"whodb" => "whodb-cli"

    generate_completions_from_executable(bin/"whodb", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb version")

    output = shell_output("#{bin}/whodb connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
