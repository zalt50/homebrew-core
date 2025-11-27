class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.225",
      revision: "937cbaef9b3491b044dcf2009385c8993eb50ed6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a83377de2aa65804d45458407a76ca3c2a94e6cc162ae8c66ffcb33c55e123a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a83377de2aa65804d45458407a76ca3c2a94e6cc162ae8c66ffcb33c55e123a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83377de2aa65804d45458407a76ca3c2a94e6cc162ae8c66ffcb33c55e123a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfbb0c2925dfd4c9b6218d37947be450b5282a1d639e137468593c98a3e891e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691245f80c8eba7e201cd6c4957b7e9b20e308fc0fa8ee2e9f2d03ae6aef2e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f12623237b3b81513d85c71bd4ad08fb9862bd0a55d64eab3c43d3359949350"
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
