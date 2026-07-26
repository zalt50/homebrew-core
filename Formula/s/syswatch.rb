class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "24b71363e9c089e892c2ea6a5d361b774240f57c228dd13d5a9e94253401435e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3e0708c17090a0f2da08310218a70c9c9f86091df1af6ffccda79082a675931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3090b2db30a108e33fc77e36af5a7c38bc8938311f5b326ddfec7a63d044b77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43fb0f4104c542fc41e3fef7f744e0fecd4168cda6192cc300c136e4ec48a8f"
    sha256 cellar: :any,                 arm64_linux:   "a308dc84a38b56cb56c5f3501ecd4910aeb051974bd99fe6a80149d082f5353f"
    sha256 cellar: :any,                 x86_64_linux:  "b5010926393059939c64dbda625f7ad0b8537896a85b4e91164ca4ae70fccf8b"
  end

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
