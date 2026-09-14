class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.31.4.tar.gz"
  sha256 "9ebc3da8164ba829544e0551577b039c6c14761bb9ab908cd54070a5eb09607c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "310a0c67eafacb5b10be17eb221d826727aca402ef087ed9d4f481188f25fabc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fed487de461be06a1ecd53e2b362cdbfa1b4998045b3383aff604aae87ba46ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "257622c6a4bee0c65676b449b6449ed3f98b94f6d04c0aa3c9d5a17a1f152f72"
    sha256 cellar: :any,                 arm64_linux:       "5a27d19ac01347655b135c815295384884fcb0dd28c044fe98e1b7e0bc25d7ce"
    sha256 cellar: :any,                 x86_64_linux:      "f251daace28cbf7fca5a5ecf20399db2487ea55820ea9ccb5029fb7353d023c0"
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
    assert_match "topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
