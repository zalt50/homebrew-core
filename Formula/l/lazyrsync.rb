class Lazyrsync < Formula
  desc "Terminal UI for rsync, written in Rust"
  homepage "https://lazyrsync.westpoint.io/"
  url "https://github.com/westpoint-io/lazyrsync/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4ce106e10a258ccb4fdf8958b49746f7a1f9386592ede441f620a7f41ffb7d75"
  license "MIT"
  head "https://github.com/westpoint-io/lazyrsync.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyrsync --version")

    assert_match "No profiles", shell_output("#{bin}/lazyrsync list")
  end
end
