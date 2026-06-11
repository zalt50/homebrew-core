class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://netwatchlabs.com"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "1d2d3dda0f2017474953c6c7bbaea898021ea8aa5d82db9baf1b5462e6279a06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8b8093e1d6a8e0e466e76bb7e4f460dcd9f51c9f049acc1268debb7eaad0516"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880302f5c1b77e73f7a6d1699c906150ba357ee27b0fb0987c022cd0e3f75106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71067e51b04c6a51376d8081bca9e34f34bd7c97fef326e94bfa82a89d2303b0"
    sha256 cellar: :any,                 arm64_linux:   "bcfdc1308ada936915e708020fdfeb8129f9a2a2b485cff3f5db60eccd2b10da"
    sha256 cellar: :any,                 x86_64_linux:  "35fa554a91e8845af3ada41caf4dcf1cb15378b0498172734901211f9c31bff8"
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
