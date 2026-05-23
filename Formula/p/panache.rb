class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://github.com/jolars/panache/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "026e5996fd75292b1c7067308ed5fb49a36851309454e026a8b840ab96f59262"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1302817a29c442c13d82a9194df8785f015422ef938e0d7278de278bf15dc8cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95af58dde6bd6f2a5f6ec0fd23536f4d1d16e3239d1263cb1f2a32ccebaacb9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf54d8da26757479d87e119fff831fef2686e007ee1bbb80d87f92d985f3d3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3cca7d3ba5dad6d3ef7a636da1148a7d15e858bb35aaa2cc3fbcdb4210a6970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4809deedad62b5f28c1de393165626287490a4bbe79a571c9397603723600252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d9ada9432839f247650fd882fece6f41031dd76e19035417f641cbe5684f29"
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
