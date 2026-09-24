class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.95.tar.gz"
  sha256 "5d78211d547fee3faef3d008f2fdb3b0858ad5f1f0a2f497fae61154d1600e07"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ca96d62581974b97db1ffe10a2c3820a08b895d6daf59076d8fc8bde9a321bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ca96d62581974b97db1ffe10a2c3820a08b895d6daf59076d8fc8bde9a321bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ca96d62581974b97db1ffe10a2c3820a08b895d6daf59076d8fc8bde9a321bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8571fa20dac44463b9c822457e73d453f0a77fc7d16a0b2a5194b1c5944ef4c5"
    sha256 cellar: :any,                 x86_64_linux:      "62d8e61981a81d0b8b9abe4417b98d74a8cc0e339836bea86b60c48c62520004"
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
