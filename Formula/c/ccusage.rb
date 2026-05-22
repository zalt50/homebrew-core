class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.2.tar.gz"
  sha256 "03c7b97f34763582f738ec7f70ed976fbe73ef47c13868ee3dd978d5473031fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f268e37b30246b286f5b896d878216082b8eb39b11d6d8386ff126a0991386fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89911578373e77676c0d1656710740579609f4df642682b45d56ad822acea7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "734b32bc69d063021c6c15aff74350383eb6617bf9d315dfa525eca714e42ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "415bdf19994ba378fd11dc9c05b2af6ba49068aa9bf53d63b3c1dc08873e80f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a4c62bbc30b2a9b59669d3ff33255380470ffa25153815584a4fa22703c1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b7fcebf7a02335b09be860ff2fcd51e7f6e14815851107544645468960ee7e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No valid Claude data directories found", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
