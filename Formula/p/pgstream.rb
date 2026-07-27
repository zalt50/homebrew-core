class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "ddf3b833b45ac9177a17f8305c4355aa74a490435047214c6aebec59edd55c00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d5c6f304eca9bf9984b8b5f5df36899f752cef981ceb82cce90036be042f7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d5c6f304eca9bf9984b8b5f5df36899f752cef981ceb82cce90036be042f7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5c6f304eca9bf9984b8b5f5df36899f752cef981ceb82cce90036be042f7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff83e814acc14c8d3f8bde6314e309e16a8593a3f45900f0c47363a54b01ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3338d38dd93fc29ee894344d28fa3eddaf44694f8e52121296e4a71f161b500a"
    sha256 cellar: :any,                 x86_64_linux:  "cc7f1296c2e60ae2a91e9468f443dbde53516ad99208d97aa190af047641f862"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pgstream", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~CONF, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    CONF
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
