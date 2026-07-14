class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.86.tar.gz"
  sha256 "efb84a095ad94717bb17c49fd5ce0938c68e0374538417fb8795686834c97fe8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaab1d213e7fe44f059864c1a6104dba59792ffffeb11174324e400af85465bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaab1d213e7fe44f059864c1a6104dba59792ffffeb11174324e400af85465bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaab1d213e7fe44f059864c1a6104dba59792ffffeb11174324e400af85465bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1815f71f47f7e375564356d40fab7c8cb81847117aeb7617ae70feb46a5c32cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bda1510baa4abf72b78d3d64d8f86da99255324d4eb53831030af979a0d6627"
    sha256 cellar: :any,                 x86_64_linux:  "32135ee31fa94c215a527b73cb5f5bb012433701df594272f143ce0798647d21"
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
