class Pgroll < Formula
  desc "Postgres zero-downtime migrations made easy"
  homepage "https://pgroll.com"
  url "https://github.com/xataio/pgroll/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "6454f2fda2f82f0b6ddd1904b3562275fb629794a8770efa5c0e97d1fc220d2d"
  license "Apache-2.0"
  head "https://github.com/xataio/pgroll.git", branch: "main"

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "libpg_query"

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X github.com/xataio/pgroll/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pgroll", shell_parameter_format: :cobra)

    pkgshare.install "examples/01_create_tables.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgroll --version")

    cp_r pkgshare/"01_create_tables.yaml", testpath
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      pg_uri = "postgres://#{ENV["USER"]}@localhost:#{port}/postgres?sslmode=disable"

      system bin/"pgroll", "init", "--postgres-url", pg_uri
      system bin/"pgroll", "--postgres-url", pg_uri, "start", "01_create_tables.yaml"

      status_output = shell_output("#{bin}/pgroll --postgres-url #{pg_uri} status")
      assert_match "01_create_tables", status_output

      complete_output = shell_output("#{bin}/pgroll --postgres-url #{pg_uri} complete 2>&1")
      assert_match "Migration successful", complete_output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
