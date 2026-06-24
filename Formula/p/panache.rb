class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v2.59.0.tar.gz"
  sha256 "06e3e73ce9515c4c2f781c4c6cfbeafbd3a72120e1e74b3258daf2184fa4c858"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2a38f0e86f3c15c9c8547dac99050a83c8a56214df95566f223d06947bdd7bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50cefb6c5e7248b78790d0073ce6f52b921d403bb8f6fa66cb62800d42907b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349aff37c57d1a6d8b483892d3009fb85a27e353b01de317172b8b6ab9a83fef"
    sha256 cellar: :any_skip_relocation, sonoma:        "65b798ab19af044a346047263254b706fe80f51f787d082da86c10969cb82022"
    sha256 cellar: :any,                 arm64_linux:   "7985cabfc3d4f1160a2909077da0b7accd1fc047afb389b02104c846a7117436"
    sha256 cellar: :any,                 x86_64_linux:  "c62afaee26e904b842fbdb0f691cb453bc52c4672459f22e77501795633b51a9"
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
