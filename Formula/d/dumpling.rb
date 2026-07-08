class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v26.3.5.tar.gz"
  sha256 "9f6d771c55d0842c0832fefc75b5e4c5563051f88f01203bad2197591ba9233d"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "492efe80fdba29044ac026f061fd34908f6a2466e6725b1e4bbff7e7adb74f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be27eaa4c5bd2409a2fb39924ffd45cb1e54c7eb446e364d3690736bd2b0ecd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "002b1f4bf31bacb7b7cb187a7217889751c4187d56df4b428adcdb1ef7bebee0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d96011a0103053c76069ef8cf9a9993c291c062c8f9875acec854c33e20a5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec49e8b1806f617a20572e48f963e6e8d1b2f261b02a45f3752ec8b8e9466d0b"
    sha256 cellar: :any,                 x86_64_linux:  "c8eeb0527f6a41ba06c5a12bf2d6ddac58768d45257e5cd5f68efe915088f3d0"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=#{tap.user}
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./dumpling/cmd/dumpling"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumpling --version 2>&1")

    output = shell_output("#{bin}/dumpling --host does-not-exist.invalid --port 1 --database db 2>&1", 1)
    assert_match "create dumper failed", output
  end
end
