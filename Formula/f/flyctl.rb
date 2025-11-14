class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.214",
      revision: "0493f2288c1febea004fc823803e5af2e6414190"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57035510b1180d59d9be99e529b905f2a109f7d3bc21996b12d47a2aae2a47b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57035510b1180d59d9be99e529b905f2a109f7d3bc21996b12d47a2aae2a47b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57035510b1180d59d9be99e529b905f2a109f7d3bc21996b12d47a2aae2a47b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e78e3e678f6467ea26ce940e24f2b55f1968681357a4da290e1a54c524e4d626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df7cd1511da838aafa0a9a5f972e3bba681fa065d646f6a38c13c820095bbf79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "337dbba7edcc246a5afdfa5d69649f02c262fc23a2ad2c20e5bd015e698f6ff9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
