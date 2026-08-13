class Bluetuith < Formula
  desc "Cross-platform TUI bluetooth manager"
  homepage "https://github.com/bluetuith-org/bluetuith"
  url "https://github.com/bluetuith-org/bluetuith/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "9586383c1703dd4e12e81f5f68e5144481aed8fb0526ee046dc3a80558d0f0dc"
  license "MIT"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Cannot initialize system DBus", shell_output("#{bin}/bluetuith 2>&1", 1)
  end
end
