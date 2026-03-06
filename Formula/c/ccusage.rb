class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.9.tgz"
  sha256 "24969ffa583e1a4daee68d3884c32ecfaddc39a9989c710d960e37fa4c806e12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3cef9aae5f546d5c9513d02323a7c3e4c2c3d225ad358128a7835e34a4281a2d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
