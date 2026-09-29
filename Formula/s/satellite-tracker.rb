class SatelliteTracker < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2b17176d0fd2ffb1aacd799c77a07c5ca3749061877ec4b7e9f60fcea022c64e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95e1ff7455de3e623d2c8098aee235d498ca002c14a95f09ca2f2d81850b84cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e3f1176e48ce806909cd6e32aeaea679fea6353a0bad61f97880c55bfc21f33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "402effae1dd52f4ee6c28d921c55e17c5f3be92063146a49fbd08beaca7e3e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5708af5d305862da059606d4d33f00946351d617c2e0a683725e4422aac3dd32"
    sha256 cellar: :any_skip_relocation, sonoma:            "e02ec3ff9cf189291eae233f7b183b1812c52a38eb264d35da0880cbaf25b37c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7dd5cacb400a734ffa52b7bb8a747ffcdbeaeedc7ce76666b9920ac462f27b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "48b732f5167d97ee80f570a12bf2e4fd618532c0599f93f94ee784ae50e58e55"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "expect"
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    PTY.spawn(bin/"tracker") do |r, w, pid|
      r.winsize = [43, 120]
      r.set_encoding("UTF-8")
      refute_nil r.expect(/\e\[6n/, 10), "expected cursor position query"
      w.write "\e[1;1R"
      refute_nil r.expect("World map", 10), "expected the world map to render"
    ensure
      r.close
      w.close
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
