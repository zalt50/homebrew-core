class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7c6bc6ddcfc32840b673f8918c1f24c2c854c55ddb48cac20dd77d8a101446b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f78694abc69f739ab72ed448c73400a2ebb17876724eeae5ee62c209ee319a98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d53031e8429506a407889e1a3f28590124184c8504825c1c850fa5c6678409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1e018612b98799b4fbac76f92636eec7e7174b7f0a84b051bf6fe42de276639"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf819fb22fb8b79a128101bc5cc166269a8a7a9ec493c6d35691dcfa2964bf96"
    sha256 cellar: :any,                 arm64_linux:   "0b056c6aa982eec17d9b181b3d0674eb8a7d5e204bc6eb7384cccc295802c7f3"
    sha256 cellar: :any,                 x86_64_linux:  "3548006b0582cede1b42d1eaa2eca375c42232429d94c4792a6b3013683aea4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "expect"
    require "pty"

    (testpath/"test.txt").write <<~EOS
      Hello
      world
    EOS
    PTY.spawn(bin/"rura", "--file", "test.txt") do |r, w, pid|
      r.expect "1 Hello"
      w.write "tac\r"
      r.expect "1 world"
      w.write "|sha256sum\r"
      r.expect "1 bdaadfc45abaf"
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
