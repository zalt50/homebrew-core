class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.8.tar.gz"
  sha256 "05998405615e62526bdf26f0d2f05641f63341bced43400de4e98ab937d1b322"
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
    sha256 cellar: :any,                 arm64_tahoe:   "be0edcca9548d1cf3886a67080293614b07c785616f627c9354c0ad459e0b847"
    sha256 cellar: :any,                 arm64_sequoia: "d8ca163be8f631515a7a9afc91927e1aa539dfc45ad68890b4469d2bca16dca2"
    sha256 cellar: :any,                 arm64_sonoma:  "8eae04908b6b00f11d2fd8c9eed615c16492b952b7ec857d71b437e9b8a0119d"
    sha256 cellar: :any,                 sonoma:        "16d57f763260abcaab594b6572d4ea529e3abf2b66d0bd558f1af1d1f6ab1ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf159df9668b97d36499652e8e655a6d131ec96b8e3d937a6793adc07919fba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c300839744686331e75eaa00f18e48f4ca5d4a0918528056bd422c8aab08cef"
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

    spawn bin/"doltgres", "--config", testpath/"config.yaml"
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
