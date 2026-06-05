class Threatdeck < Formula
  desc "TUI threat intelligence monitoring and alerting platform"
  homepage "https://threatdeck.io/"
  url "https://github.com/gripebomb/ThreatDeck/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "eca039c274ffc0c1f121d2f5f22f68d070011b2754819aa7a6ed58e50c9b5b7e"
  license "MIT"
  head "https://github.com/gripebomb/ThreatDeck.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ThreatDeck"
    sleep 2
    # select settings tab
    input.puts "0"
    sleep 2
    input.puts "q"
    sleep 2
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "Alert retention", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
