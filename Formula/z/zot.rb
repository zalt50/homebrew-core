class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.94.tar.gz"
  sha256 "b452465079769eb4c505d937ed366224b8b7afca7730f8b2ec940030bb0eb083"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "152bd80db965fac1e03a6588babbf014ead045a0649ac3d5226eb110422e2be1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "152bd80db965fac1e03a6588babbf014ead045a0649ac3d5226eb110422e2be1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "152bd80db965fac1e03a6588babbf014ead045a0649ac3d5226eb110422e2be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6565303b0b37dbe424cb1ced5aa6c20c6478b187d8607294e39ece5f63c313ae"
    sha256 cellar: :any,                 x86_64_linux:      "925d93ed628e52fac2d724d2d3fafa15eb9c85d45c090d56544aa02ec7490b99"
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
