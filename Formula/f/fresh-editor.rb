class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.41.tar.gz"
  sha256 "a5c30a8a03182ddf726dab40b6a8c96b6f4188d7338abd4c02b171a4ed37f834"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d3d19f81e006ad7b211cbb6cf93016b53413266aafa6e5c39a688efeb253630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d418accbe84e39f616f286e343857a33d967f6e5cee7c37ecb3f29e20d5f67cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa6bbf69659c6c6d6fc44f9a95b2ffbe31646836d4fd164dfadf5779c319b1da"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a6569b4fd2a3697339038f474dc2a4691c89e7ce3dec761dfea0b23d91fb68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac35799c757ecd71524f38576b962d8c28217d04affdf8f5b4765ef61fa9787c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bee9d745f29683efe18a069aaeb6b21ee778372f3c597387d871f2717b8db8"
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
