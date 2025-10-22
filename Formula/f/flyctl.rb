class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.201",
      revision: "2b8da2f14817ccd05690e3246101528b0fddb82d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04fa981dd82e30a54c314f4c52355f46ebf8466682a2d111dc0f76043614f19d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04fa981dd82e30a54c314f4c52355f46ebf8466682a2d111dc0f76043614f19d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04fa981dd82e30a54c314f4c52355f46ebf8466682a2d111dc0f76043614f19d"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd60b81fe8a51e493a22ec1239e738cb78147d84a684c244c8c5ff21a87b175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67aa6f221c6cf8d36a289b8ba92d7c2950a0a21f106a97db66a700ca3309ac63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a4561403ae37a2bb12b29a24501f74401578d9bc5d7ea77610af5b27f231c0"
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
