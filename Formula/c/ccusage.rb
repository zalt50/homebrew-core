class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-19.0.3.tgz"
  sha256 "103384865cef17a6e4df5d5f9154994b1c9d44dd0ef5240a0b4aa4a7d38c1e4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3452743bcc421e8774821390e1e48dc9cae9aa3b181568ade034989023f3bf8f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No usage data found", shell_output("#{bin}/ccusage 2>&1")
  end
end
