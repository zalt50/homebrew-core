class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "00fdccff473c51c26f2184d02cf249da2d5b973381a32e41c8049501ee554f65"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
