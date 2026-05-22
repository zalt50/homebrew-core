class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.4.tar.gz"
  sha256 "d007e8116a03cd19fd74ef39ff9f965b2b269d46cbad9cddf2c583bc22f320bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62ec0a47fc5ccc486ce6b27708b3c238f17b249c526e04e56a1591d36092742e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1bc47ab097c15825fde1ae6a25b3015a2bb2585b05b7ee5feace920e7e0cef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a727faa721d477e0538bef81c9a31c8e4fd57cdc22da4a7e64c906486c29d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1780ff6c4bdace61cc4ed94f9c46a24258b23267730e74704ce324bdf613fd80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68d91fda2dee54ea03e097a04f2ed4df185e812461ca1eb0fff42fa2eebffd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e72ac82f3fb690a8c1ab8e17ed962e58bb5b7d826917c7619028eeee6eb1a07"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No valid Claude data directories found", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
