class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.9.315.tar.gz"
  sha256 "44b28cd9a1181d596cd74fb26a4c02e9f9ccb01918f7a1ae351321eb4c15644c"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db54ee1e34667e8173434ea97d05ca3c545527560f5050232562140305ed1b6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225acb1a1032adbbae22dc77ed1f0d0b9b833511b9cfc9e30d4ada4a8a5c3738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f04ea6e9fda483ec423d9008ffa4684165798888463be455fb16a55b0cdc82bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6391853c3171f92036447edae6e0a05c589c9cf70becb9e0b04dedd9c8c3e41b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8003414e95d9b97495a276fb35a53a969eb29a8179b919585629fddc2181d2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a4801a25213e2b37abb40b3cb304eef543ca2122f08153ef8b0a421c171f20"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    tags = %w[json1 sqleanall]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
