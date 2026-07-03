class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https://anyquery.dev"
  url "https://github.com/julien040/anyquery/archive/refs/tags/0.4.6.tar.gz"
  sha256 "791b4be32ae031ad6321116009e7ddc13464273f09a7afbea0501e0d33df58f6"
  license "AGPL-3.0-only"
  head "https://github.com/julien040/anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d8090ba59202a1f92ad22f684842b29495ccfb92fc47149e54a8fe27d506201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4edcd47b4dca8dae0ebdabe79342985d199975255fc7460b02f78fa1f6dd85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7cbf404925ea69b93934ac3fdfacfcd076e578587fe7af4352ef53b13278aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e560ac288958b5e635c313d8099e2356da1b095e49dcb2445ddf3cbc706bb43"
    sha256 cellar: :any,                 arm64_linux:   "5885762dc6c9a78aa0aa202813d38fa3bbaca984fc63906551c30fbca86e7e7b"
    sha256 cellar: :any,                 x86_64_linux:  "00a2af01fb4fa1804c998689309855c6b6cf080d2304d787c56e3e9d0bde4162"
  end

  depends_on "go" => :build
  depends_on "mysql-client" => :test

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    tags = %w[
      vtable
      fts5
      sqlite_json
      sqlite_math_functions
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)

    generate_completions_from_executable(bin/"anyquery", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/anyquery -q \"SELECT * FROM non_existing_table\"")
    assert_match "no such table: non_existing_table", output

    port = free_port.to_s
    pid = spawn bin/"anyquery", "server", "--port", port
    begin
      sleep 5
      output = shell_output("#{Formula["mysql-client"].bin}/mysql -h 127.0.0.1 -P #{port} -e 'show tables;' main")
      assert_match "information_schema.COLLATIONS", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
