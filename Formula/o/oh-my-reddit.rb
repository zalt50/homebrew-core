class OhMyReddit < Formula
  desc "Beautiful Reddit threads, live in your terminal"
  homepage "https://github.com/renatoworks/oh-my-reddit"
  url "https://github.com/renatoworks/oh-my-reddit/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "623db2b5489557f9b44cff6038b83ffecd8b35fdbd83766a78b52327a7f46ce6"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/oh-my-reddit demo"
      sleep 2
      input.close
      sleep 5
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").binread
    assert_match "t post", screenlog
  end
end
