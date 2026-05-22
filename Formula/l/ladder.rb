class Ladder < Formula
  desc "Selfhosted alternative to 12ft.io and 1ft.io HTTP web proxies"
  homepage "https://github.com/everywall/ladder"
  url "https://github.com/everywall/ladder/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "e837284c3e283d7de1441b55606bd54ecc10bb6c81abed5a96b9e6836d7d3a2a"
  license "GPL-3.0-only"
  head "https://github.com/everywall/ladder.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main.go"
  end

  test do
    port = free_port
    pid = spawn bin/"ladder", "-p", port.to_s
    sleep 2

    output = shell_output("curl -s http://127.0.0.1:#{port}/")
    assert_match "ladder", output
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
