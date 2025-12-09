class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.8.tgz"
  sha256 "b096e717a0367108240397daf52dcabd185884df1b0b731a3b263b69629c9f06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d66f769b3eed2153c4a8f89714cc8f9c7116b58216ba3390747b2bdc58026f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
