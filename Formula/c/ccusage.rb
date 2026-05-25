class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.5.tar.gz"
  sha256 "e9a9cfb98d88e6aead0bfba7ca61370c62c7411fe4c538fd16915078f313a63e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79e89265db6817472bc4530f3fc9788b8c7ca792840595eb90c4adb44952b5e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61e0335b60ec26747f2c5e1c408141595eadebd902fdd348509c830d06956b46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9c4de3bc13989295657518e6519e2e8a0f856e982f7ab916fec80bb9f7eb0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "095545b23d33f9648dd54ee5e150396355da03007e85b313acc9f319935c9edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2981c85ec2aacd4972f682fa08221bf06e98c32e091def1855a7a7cb881642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b2b47eae1108f54aab3925a173bb8d5c2a12c6e686308969c4b8aaa7c7219a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
