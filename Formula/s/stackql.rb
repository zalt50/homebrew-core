class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.10.542.tar.gz"
  sha256 "ce3c15b1931b69d20682037d21bb7c2043eb100f66f28799d0af7dfc0891ec81"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16d07ebb2bd570d08aade87d756c149d8bda8654ec11ed19e492b621557026ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cebf473d97fff6a90d5862ab5536372dcb2c55db4db689ed23b821bdb925d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d145ee36bf3d67a2084ace59049db146eae9851cec9ef0d7b3025f0826d81c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "a056a380d2271436e10fb0d149314f6229794a7f6edc55d4680ec9ddcf34df70"
    sha256 cellar: :any,                 arm64_linux:   "f31b7b14ac736948958db0adc04da0c949f5300b8692cfe9de9e4da427be39d3"
    sha256 cellar: :any,                 x86_64_linux:  "38ddf1ff5ca33db69251789f577969579f11f5e69ac75e0f861c50317b895d8a"
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
