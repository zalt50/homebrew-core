class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.81.tar.gz"
  sha256 "73233e2750800d0fb1d1242a50b61b9f482aaed0167f5c27f54762d7beb43e3a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f641b31243482a14c8cc2dcdd2d9416ead4a0530cea33a78292e27c6b9c258c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f641b31243482a14c8cc2dcdd2d9416ead4a0530cea33a78292e27c6b9c258c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f641b31243482a14c8cc2dcdd2d9416ead4a0530cea33a78292e27c6b9c258c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea9572b727e3b433f104830175390027b7b945d91b4881201fba5d1d8d127e71"
    sha256 cellar: :any,                 x86_64_linux:      "ef4c36599bd4a9ec656d3bde678427607949b228fb398fb03b7d1fb965953c09"
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
