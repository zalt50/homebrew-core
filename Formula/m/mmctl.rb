class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.8.3.tar.gz"
  sha256 "6460842e861a4b96d786845bf51b49ae72804346a10b5f5dbf8d5c288c3fceaa"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12484a1041dd9d03e0a4c823b257c1f64f19bee7e649db94c3d7188e68e1602d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12484a1041dd9d03e0a4c823b257c1f64f19bee7e649db94c3d7188e68e1602d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12484a1041dd9d03e0a4c823b257c1f64f19bee7e649db94c3d7188e68e1602d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f548e42de48f3902f39ebb42208a2a66e6e7620b5072b1b4b3d97cc42f769f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7cfa7d21e586a1f1c3729ebdd3184b7bb98eac89356e35d61196ccb1aa4f93f"
    sha256 cellar: :any,                 x86_64_linux:  "79789b4d8f8c3a68b3bb76857f26d424fc3abe97d0cdfb7098a4fe99eeffdd2a"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
