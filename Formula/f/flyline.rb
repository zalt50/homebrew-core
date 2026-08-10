class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "9bcacde196d9b46550c1b87605e8ef30c6bdf907d4a0816bf6f9348b57645cc6"
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
    require "io/console"
    require "pty"

    output_log = testpath/"output.log"
    PTY.spawn(formula_opt_bin("bash")/"bash", "--noprofile", "--norc", "-i",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      w.puts "enable flyline"
      w.puts "flyline version"
      w.puts "flyline changelog"
      w.puts "exit"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end

    output = output_log.read
    assert_match "# Changelog", output
    assert_match version.to_s, output
  end
end
