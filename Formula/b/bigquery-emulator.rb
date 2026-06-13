class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https://github.com/goccy/bigquery-emulator"
  url "https://github.com/goccy/bigquery-emulator/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7d26ebbfa24b6adb7c920e05645dc1d33a061d49f077acb3c459a8c7cd0ee300"
  license "MIT"
  head "https://github.com/goccy/bigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fa7217894d18af35af384f12d60d1542f9f6094c3c367ef948a3f4571077369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa7217894d18af35af384f12d60d1542f9f6094c3c367ef948a3f4571077369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa7217894d18af35af384f12d60d1542f9f6094c3c367ef948a3f4571077369"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc1ded740f62a2a70c255862dc7df35226f9177798a043d2a3c470ff1917d33b"
    sha256 cellar: :any,                 arm64_linux:   "1830d1f0792d3aa619244d8c38a992b19feb4120284f62a0fa2cc165b79df2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d235841aafa163b1479e287d1b5cb6dbd4365af973fe8e0d443f26d29d3dbb"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "0"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bigquery-emulator"
  end

  test do
    # https://github.com/goccy/bigquery-emulator/blob/main/_examples/python/data.yaml
    (testpath/"data.yaml").write <<~YAML
      projects:
      - id: test
        datasets:
          - id: dataset1
            tables:
              - id: table_a
                columns:
                  - name: id
                    type: INTEGER
                  - name: name
                    type: STRING
                  - name: createdAt
                    type: TIMESTAMP
                data:
                  - id: 1
                    name: alice
                    createdAt: "2022-10-21T00:00:00"
                  - id: 2
                    name: bob
                    createdAt: "2022-10-21T00:00:00"
    YAML

    port = free_port
    grpc_port = free_port
    pid = spawn bin/"bigquery-emulator", "--project=test",
                                         "--data-from-yaml=./data.yaml",
                                         "--port=#{port}",
                                         "--grpc-port=#{grpc_port}"
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    query = '{"query": "SELECT name FROM dataset1.table_a WHERE id = 2"}'
    query_url = "http://localhost:#{port}/bigquery/v2/projects/test/queries"
    response = JSON.parse(shell_output("curl -s -X POST -d '#{query}' #{query_url}"))
    assert_equal [{ "f" => [{ "v" => "bob" }] }], response["rows"]

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}/bigquery-emulator --version")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
