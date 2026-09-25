class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.69.tar.gz"
  sha256 "38cfbc34fe95c95ab529e72f57fc0f8b0694a102333d72a7515e0a0c4b0ff465"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7604c4576be8972d4aa363dd10c1a200fcf375f4c92118c5bdae369b93937d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7604c4576be8972d4aa363dd10c1a200fcf375f4c92118c5bdae369b93937d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7604c4576be8972d4aa363dd10c1a200fcf375f4c92118c5bdae369b93937d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b70e03be00f47260b574daf12c509d1b8e48fd5cb0e8e9b63bc252778b4d0dd0"
    sha256 cellar: :any,                 x86_64_linux:      "1b243e40fb1c674b7ceae5892650683daa558620a9ec43a2a20ce34763f81c2d"
  end

  depends_on "go" => [:build, :test]

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath/"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath/"func.yaml", "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
        socket.gets
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
