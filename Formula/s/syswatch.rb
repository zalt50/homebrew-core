class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://netwatchlabs.com"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "9f79f8748f0e0b4837bb2ceb55a80360cfd29c93d0914619a1cb1ad57c0d5922"
  license "MIT"

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/syswatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").read
    assert_match "Services", screenlog
    # match text in help dialog
    assert_match "Procs tab", screenlog
  end
end
