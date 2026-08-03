class Rura < Formula
  desc "Interactive TUI scratchpad for building shell pipelines"
  homepage "https://github.com/tlipinski/rura"
  url "https://github.com/tlipinski/rura/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "af88f649ad0be5fd55639b50d3ebcd716afe1e6130fa52a21bb13f1727dbeaaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6510ea8045ed70a7049fff7f798913fe021e3b523a2c4a00f87f197c305926d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9b717382a70f2404dcbc68f4db073baff1a2c5841e99665c123a4d79124b4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c601b3d4feda59fd934f0acaed3e4f7f0676f323b71555ad2e36d565459cb751"
    sha256 cellar: :any_skip_relocation, sonoma:        "929d0216b65fe504b15f758d83eba27dce86dcd90a041fca47b46f276afe21ab"
    sha256 cellar: :any,                 arm64_linux:   "0216291fb5984183b332e48fa86d66f71143c920dfb88819ef93c4d19dcb6234"
    sha256 cellar: :any,                 x86_64_linux:  "6582d51c7fbcfc9bca0faad4c0c130982a1a3531285c53b032a32d1285ffa830"
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
