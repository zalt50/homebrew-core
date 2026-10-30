class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.58.tar.gz"
  sha256 "ba765f496d1d1c21b36e7ab986f41390fc3efdcfd00416346f5e20678383df02"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "349d8004daa2e633b67a88b840628baa95e78af99be3c87ce68718baf1f3f0dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "349d8004daa2e633b67a88b840628baa95e78af99be3c87ce68718baf1f3f0dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "349d8004daa2e633b67a88b840628baa95e78af99be3c87ce68718baf1f3f0dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b966bc76cac12027135e2cedec63499e1f150306772f29fc9d5e2923b1a164d"
    sha256 cellar: :any,                 x86_64_linux:      "7faa7db5f552df28f1adcbad6d5a82114effdb0dbf67bbc845d6acd6678d9be5"
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
