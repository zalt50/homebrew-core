class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.0",
      revision: "641eb1c8b884eb191d574de8e11b8423e86e3260"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a11de6699ebb3b7ff3df7c886fb97ab574b3d09a06770ebb70b327a1d2b5bce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a11de6699ebb3b7ff3df7c886fb97ab574b3d09a06770ebb70b327a1d2b5bce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a11de6699ebb3b7ff3df7c886fb97ab574b3d09a06770ebb70b327a1d2b5bce"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a52cfd75998bf7ec3b977af9d01138f2b5bfa3afcd10676b9fb9c003e2b569"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24a6a620db738dcb66968d06d46cc159b3ea710c9b171bcc982f28eee131c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3099eef290fc7990704ff3842d23826264c60387c23fa723d10c16f812ae10e0"
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

    %w[flyctl fly].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
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
