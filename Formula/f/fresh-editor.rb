class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "9207740b44840e66a750cf992a8c998512b8809c5e338b253e85fae7b1d10b8d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccb8e342cb9ab3b5f18a8a83ad421a1735d59485390c7e3a381b40d45c68a75a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754250b67c3a928b0677d1608863dd6bf1946488dfc50de75317d667645170f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d211d4566ccc233048c3a31f5ae5eeee8de0322f89b9e84c8076840eb83a334"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e35e6a2522c78f8a4af6dca38b79dd8cecc10558fb82ac64fef5625fd492373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9743a0864c605bddb3fcec6578a926ed8e686b97b69d9d4791f46b17d32512a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edab7b7dedce3794e5f38eb57d67d6b409888b469e1a947b038d99573f1f6f0b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --script-mode --no-session test.txt", commands)
    assert_match "Hello from Homebrew", (testpath/"test.txt").read
  end
end
