class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.62.tar.gz"
  sha256 "0d2906854132be79042c4682be889eefc323cc005263db1b61a585f77310d692"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdaefabe3615e771cdafe43c2e5b409ef0349247b80cd661b85e059f87deea9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe3d6d02962d94d632127faef28a5fced95c7f6939eae3802457d90e9663853e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f9a202277892a209736871035076903e2b278de5bc8dd0f9ae8dac19ed3f09"
    sha256 cellar: :any_skip_relocation, sonoma:        "a96b87efbb94d096121a531ed8bb66aefa8588addc0e58cd24fcef57b91bbd46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8175772df4958977c39114864dbcfed5c6440d18449591fe1f7b1d0daf70d48"
    sha256 cellar: :any,                 x86_64_linux:  "39e6d0d09c771e30c1870ef522c3939bdc3b0183f6194d6d311fbc057511ba1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
