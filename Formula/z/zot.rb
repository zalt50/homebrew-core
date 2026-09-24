class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.93.tar.gz"
  sha256 "4f88f1037a9e9a8f83e6dd294d33c20075d850e5bc74f1982fcadf2bc20b2100"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c0969a0144ed1d2dd95348984298a526695bc50ad7e6b393cfb40b9790c9e1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c0969a0144ed1d2dd95348984298a526695bc50ad7e6b393cfb40b9790c9e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c0969a0144ed1d2dd95348984298a526695bc50ad7e6b393cfb40b9790c9e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3f375f798dff66172ba68f8c2ec370780cbd975c0022baa529afd03ce907fb3"
    sha256 cellar: :any,                 x86_64_linux:      "b15dbe948a005a08e6b92e3e702a4e89a196ed4d8e5ed61773341dee60a20436"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
