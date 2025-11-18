class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "921fc15552927b6a7c2e9dadf0e9ba86177dadce04d3f916094aa9f546cfacae"
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
    sha256 cellar: :any,                 arm64_tahoe:   "7565ef3b343723588025efa21310c8efc1f06fc4b26d4f9964f78f9324c5ea7c"
    sha256 cellar: :any,                 arm64_sequoia: "800cb7f4a3c1b18939376ac08af735c5a690287d0f8d6221e88979a266f0a107"
    sha256 cellar: :any,                 arm64_sonoma:  "9ce51937f93779ef4049cad7dd5a8d1c635784468caa3a033d2708a7ddc69bd9"
    sha256 cellar: :any,                 sonoma:        "268af176255ad0badb015baab4ad98a85dbaaf454e07af5afe631e9ded4aacd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d10f3997b8af03075be633f6aa1220125829148b12b007541e9f3ab1aa7cddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e8f7f7082a49aa5379cee904190abaaa41f076326dbba392bcd2eababd8db6"
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
