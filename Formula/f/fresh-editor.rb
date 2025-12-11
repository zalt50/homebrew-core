class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "1f9191a3b098e6d90a481fb8850edd1747d5ee1b5fb6961921f0c3769a44c610"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8cf036cc7e235f67c34a4ae000d4d89701bacfe1ec1e9946c1be6fffc32ad0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3654e5f31b4ded06ac7fb1315a6672a059af1e6d284580d6fe11dd76416f572a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c4e0de696a3668f9d964a62140369d6fee4d37b91275019134e2897590f551e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f9b2ada7fe7afe3bcaad581a44ca96353f08d4d2a1838c7dae560992f28abe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd3f151278d414bcbc242649ddee8c3f469bdcad3069c0d6ce8d723cecf94ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd3b1fd21dfb5c03951d7c38fc26053f29a2f897e27b9fc3ef1794d0a0021b9"
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
