class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.22.tar.gz"
  sha256 "56965a96e7e512538d68ee6dc345ba816f38a5f61cddd8cf1a511e8c19e096e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6012c2648679463cf4709d0ab4a2e2381d6f0784facfc29b3e493244ce6ae9d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8b6ae9ffa54abd47b86ba4eac175de878095ca1d1a831502831b9fe1597903d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39db865ddba39ac1c9e517a8ead028abd455095b6adf728baea7a5f77202f0f8"
    sha256 cellar: :any,                 arm64_linux:       "1943077f5bb2126a1124f1957c28b1d0e5889b769a172118c75402e2665d25b0"
    sha256 cellar: :any,                 x86_64_linux:      "79d9216552de8111ba0f2db07dbd6f570ab7fce1afb7366807e7ad02eabaa1b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
