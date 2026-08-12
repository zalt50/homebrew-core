class Cliphist < Formula
  desc "Wayland clipboard manager with support for multimedia"
  homepage "https://github.com/sentriz/cliphist"
  url "https://github.com/sentriz/cliphist/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8d7dc7b4495e5812b5613274c250ba5d3900933d78888ce7921c01247f191cc8"
  license "GPL-3.0-only"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "echo test | #{bin}/cliphist store"
    assert_equal "1\ttest", shell_output("#{bin}/cliphist list").strip
  end
end
