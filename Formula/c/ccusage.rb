class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.1.tar.gz"
  sha256 "326e0da0fc6d92b51c0f29d9b1a146b452705720170e3d28f14bdc432c489eb7"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No valid Claude data directories found", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
