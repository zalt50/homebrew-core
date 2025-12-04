class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.3.tar.gz"
  sha256 "5699888d22e31d6c59ccc65bf2d34856c524425e8441322bf006aaadf7772977"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02520fe8b27046ebdc4e5917b9b7c5231d944f9ba1f22524b5fbad3c9962cdf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f4451f06c34aa1740de88c1302338f93178627ccafc6e3e2fb01a5d0db1578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f6c08fb8a271c160372c839967ff77299e499df7179a6745886193f3275621"
    sha256 cellar: :any_skip_relocation, sonoma:        "158a264210b361fdc2abd5a7b3673c7aa642d8dc3e00e010a4b8218385f196b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11ff0634fd754786fd3bf9a5810be32883add8e400a2e4f8d82822b8eabdab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7bda11763fa8dfe14e7c46abf04f7e8bbc7992160bb86e3c1b8ba42314d6e8"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output

    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
