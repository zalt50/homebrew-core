class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.9.311.tar.gz"
  sha256 "423f1ca086c8aa192620f0859db819c59a2456bc36dcfa530ce303af628d2a82"
  license "MIT"
  head "https://github.com/stackql/stackql.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efae8ee0fc3dc851e29fe45f0209a7963fa3c3f3154c352d9be82d50bfe3b69a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b8c6e29214c3f073922bc6f8b582537ec808ed47544c73142de958e7e6caa55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226e99281710e1b4356b17ea3c03e2fcfb06b62147a3a1d1f0538c951af4608d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a0c6fac2b98aeb00c9480f1a74541fec69a9dce772aaa122712dd77f427c8b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d72ecf0d12f5cea0bfd8fcf9ae945082b4c12e5e8303dff4c1a59e646ec0f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1abd46263690665bee87e695eb23abbeec08fd1eac453c81e231ed3cdeda533"
  end

  depends_on "go" => :build

  # Update `go.sum`
  # PR ref: https://github.com/stackql/stackql/pull/595
  patch do
    url "https://github.com/stackql/stackql/commit/e4dcd39105323d68f058ef938e428ed4a8a37025.patch?full_index=1"
    sha256 "9230b53241076c7cd1ccc55d516982b94974a4fbf9f123a8387530257525311d"
  end

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
