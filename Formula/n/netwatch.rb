class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "db428f9a85b930a37da33e2bd3ff9dd13c867de3e222e70a20c29e2fd3d5378e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e4e6ad57554491a940b90010b8641fcdbfdcdc1e2d7eaec9cb10d4767f74442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fa49581887b1e6a9a92d1bcaf7f35069a72b1f0098c27c6a891e2a60c401ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5adcde313d4d5a6a9423ef6291ad24b47d613bd4d2035d48f4481d17b7d06261"
    sha256 cellar: :any_skip_relocation, sonoma:        "485d950ff9c10a509e58dce016d7a245a0ce185202e4427a0d4e069fc18847a3"
    sha256 cellar: :any,                 arm64_linux:   "655fd75c2e201b42dbcb9adcbf593daf50265fb01c360401c955fdce40299318"
    sha256 cellar: :any,                 x86_64_linux:  "6ae2609fa8d2a126e3067b3b16f8b24a78f2df05818878daeb6fa9374cd9196a"
  end

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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
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
