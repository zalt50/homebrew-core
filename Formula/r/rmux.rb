class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.6.1.crate"
  sha256 "0dbcc917c881d1ceed1bd93caa218b59d192a48248aafc7fd9bf87fbc541a19f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f942f6653c9fa89f505470c816e401d38e4c5d14d13aa148a14b4438314e38c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab18315be94a14d030561aece628af4cf002e83a2acd32f3f4dab227add11d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d4faa0d3d30f0624122f7b715af1c241ff542786df4a8b5a14be991573a9e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e08c32ae1fae60e411c106ee927557c94bf18c518147f726d59f111e5b2020"
    sha256 cellar: :any,                 arm64_linux:   "23b1356255d0c198012f040fe7d811f76832039ef9d4bd1d2fc716f27acd26f5"
    sha256 cellar: :any,                 x86_64_linux:  "a4e192770cad19c4ed281c10e66127f3526faea5b0fe63ef6a53038e3173703f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end
