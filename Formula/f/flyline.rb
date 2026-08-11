class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "291981585cc7cee0372ec93242bebd3a70b1fc0e9475e1adfafa3932cdf20e31"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4a87e114643af1da1ac043d84270977076f197a1f87c00d7c41aacba09f03e48"
    sha256 cellar: :any, arm64_sequoia: "1a1db080233e3ea073f815d8a707aa8e1a6cc36beb13a570919821b5a0235621"
    sha256 cellar: :any, arm64_sonoma:  "3a23c43d30175ee1b546f5b5b05b9c8e4764bef6d05423f4df8c107b7d1e9bcf"
    sha256 cellar: :any, sonoma:        "e2d0284040ef8a2d29d91e0ba81532f34e7b78822acf339892e763f4c4b0aa70"
    sha256 cellar: :any, arm64_linux:   "3f19b28fe81cea21d3c97e56c200e1775f854572428f58859734fdd6d5768187"
    sha256 cellar: :any, x86_64_linux:  "399cd21cdfe05c075f3ca415da644f48e2c46f541078097d0bf1f9f38b9fa36c"
  end

  depends_on "rust" => :build
  depends_on "bash" => :test

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"bash").install shared_library("target/release/libflyline") => "flyline"
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, thr|
      input.puts "#{formula_opt_bin("bash")}/bash -il"
      sleep 5
      input.puts "stty rows 80 cols 130"
      input.puts "export LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
      input.puts "enable flyline"
      # The terminal backend blocks on a cursor position report for each capability it probes
      input.write "\e[1;1R" * 10
      sleep 2
      input.puts "flyline changelog | grep -F 1.3.0"
      sleep 2
      input.puts "exit"
      sleep 5
      input.close
    ensure
      Process.kill("TERM", thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").binread
    # Match the tooltip that should be displayed for the last input line
    assert_match "Display the changelog", screenlog
  end
end
