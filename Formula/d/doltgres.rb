class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.6.tar.gz"
  sha256 "7422369242bd51fa3f11a9f9cf50255ed8f985e11dba7f4838b4dd817f4916b0"
  license "Apache-2.0"
  head "https://github.com/dolthub/doltgresql.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e35e3e962be3ad06c8add1d09110c1bea5d748e91825d925f059bcb57d8df2d"
    sha256 cellar: :any,                 arm64_sequoia: "9332884c659bcac2cb5dbd44cbc68c05feac6bc11120c6392ed6b6539cca752c"
    sha256 cellar: :any,                 arm64_sonoma:  "595a58daec65c8c4afa42ca7b003a0e1c02cc8cfac75c31c6cea2541d115b309"
    sha256 cellar: :any,                 sonoma:        "1863dd0ccc7abdfcb9b79b328e0e8d4bf83b65b0a50f5d471c909d6e9b841ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffa163bf62cc9288b27cf4ea3f7f822d342b871ab0e80b88aba945b8976512fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6ef5fe4540f99ae059cddffd922491b5277eb7294ae2bf89820df889ce2b89"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      log_level: debug

      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    YAML

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
