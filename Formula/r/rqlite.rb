class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.14.tar.gz"
  sha256 "e0ff8df4bc9db7604513de19b6f15e477f9e4a1627b298d90c165152658ff963"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76fefbc9fed14d1057b38a1b7f1c656206b0bcecfcdd37684ec2771a425614f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d400ce1e8def98b1b53170756259ce7f2bdef264bc4e4ed998fce9766d0ae8a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa29196dd55c25215fc2c6249a064e64b97e3e678941ecf738875e97189a9bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d611832046c20f06e39bb63aa416d21b2a51ba91481e61d22dd1235378add93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b80df3947acd8bcd9727ab8ccd17a4ff255390cbfa3a9e01fdc0d782c0088758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdd379639f58854a5c56d6d69fa3a7aca6bd9f36bc0ea67f2342c48836ff0a3"
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
    test_sql = <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL

    spawn bin/"rqlited", "-http-addr", "localhost:#{port}",
                         "-raft-addr", "localhost:#{free_port}",
                         testpath
    sleep 5
    assert_match "foo", pipe_output("#{bin}/rqlite -p #{port}", test_sql, 0)
    assert_match "Statements/sec", shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
