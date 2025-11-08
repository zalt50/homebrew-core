class Gotun < Formula
  desc "Lightweight HTTP proxy over SSH"
  homepage "https://github.com/Sesame2/gotun"
  url "https://github.com/Sesame2/gotun/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d63768ad7ae61b2fa29f100e22af19b9d43886eb85712e64c58d24b9408b92c1"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotun"
    generate_completions_from_executable(bin/"gotun", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotun --version")

    port = free_port
    server = TCPServer.new(port)
    server_pid = fork do
      msg = server.accept.gets
      server.close
      assert_match "SSH", msg
    end

    require "pty"
    r, _, pid = PTY.spawn bin/"gotun", "anonymous@localhost", "-p", port.to_s, "--timeout", "1s"
    sleep 1
    Process.kill "TERM", pid

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "HTTP-over-SSH", output
    assert_match "localhost:#{port}", output
  ensure
    Process.kill "TERM", server_pid
    Process.wait server_pid
    Process.wait pid
  end
end
