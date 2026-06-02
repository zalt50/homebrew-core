class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.60.tar.gz"
  sha256 "d614fd3d6e2a741d416e8fec752f1c5f9961208fae546f30b688f5fb2ebc2fc6"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "539de76f173a40cb3571e112314c3a94854ddc4706837039eaebf3c6ba2de661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539de76f173a40cb3571e112314c3a94854ddc4706837039eaebf3c6ba2de661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539de76f173a40cb3571e112314c3a94854ddc4706837039eaebf3c6ba2de661"
    sha256 cellar: :any_skip_relocation, sonoma:        "b01878f0d393c42c41d3c709ab029b92e78bcaf6855c3e8912f040e8a35b5f45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "525e6235b50a16271d96f92eb18429e18316547a19cf81c09390e3fa6359bd1c"
    sha256 cellar: :any,                 x86_64_linux:  "d377b09dfeed1a93b12fbe61b2cc803745d1e7995741fae441e6ef53d635c992"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
