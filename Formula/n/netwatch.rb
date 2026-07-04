class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "3600dadbba659d56d2dede32a384923ebf3cdf91af96c13b1efdaaee23302ba9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6704a217251ad83f681bdab6f14bd4c5a57b976c624c34f126e5578161230fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548135d3ad63e4df11718eeebf64b1a836330718c40ceb88543ddf92f70c4b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096b41d2bfcfab64c41637cbd2d82ae70e5a95fdbaeb9189890e89bc609dbb59"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd7e3e7a0eb5a0e6a66fc8ce2996f337715bf77c1a229fc75869c06afc4dc4d"
    sha256 cellar: :any,                 arm64_linux:   "919da95c23c42275bd52f61c2011aa5c345afaa7fbd25d1ad59b66c7ecd94153"
    sha256 cellar: :any,                 x86_64_linux:  "9af43ddc21f5160361ae25e2c483ec30caf7cc3cf9e02f24b28704a78d7cb489"
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
