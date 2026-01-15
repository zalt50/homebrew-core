class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "d223340a8f6374a4a1755dc54aabb06ea7603ca397b883f118314f2fe7eb5015"
  license "MIT"

  depends_on "rust" => :build
  depends_on "r" => :test

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
