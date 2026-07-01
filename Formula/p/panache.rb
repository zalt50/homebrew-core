class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "2d5d01c6793feee7d6abc081dc22c076ecd4591bf68e677f5ba8728469a2323c"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e386958632857174196ba9d5aa9f8c3b7913e506dbdcae7b8537fbee85e2c4c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8ba4d77ff25ab470470cf348a262cf730cf67ecbc1b29951750964a399ba465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e03c2600e3fd7faeb250988ed3ba570281664433e8782f7ab7d234759dd81b"
    sha256 cellar: :any_skip_relocation, sonoma:        "95fddd430a75d0613dd7ebc4f1144e5d4dd5adaca2fbb4b22a3271564a9d149f"
    sha256 cellar: :any,                 arm64_linux:   "ade6778f0242ad78425203ff13d54c23314ebf4fc58d4b7958462c3cceb5727e"
    sha256 cellar: :any,                 x86_64_linux:  "157686b1d02dc24c3e7f21e5eb85691a8ff8cd77cf8f8dbe95a09a3b03cd403f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~MARKDOWN
      # Heading

      * one
      * two
    MARKDOWN

    output = pipe_output("#{bin}/panache format -", input)
    assert_match "- one", output
    assert_match "- two", output
  end
end
