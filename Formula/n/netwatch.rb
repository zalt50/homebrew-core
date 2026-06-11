class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://netwatchlabs.com"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "c363a044118c870d96a50999a989033a4b662cf0800fcfc8deb948bee99b0b2e"
  license "MIT"

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "Topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
