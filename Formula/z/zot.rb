class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.63.tar.gz"
  sha256 "742135546adf5e0e436138d866963495537f4223a011aba7f33f1b29a4b7d5c8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d34cd00cb117d7d7bbbd1445b508504a2c7f39321ee2f6fec5a814de8f17e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374e20051fe4a967dc6e601129f52340ad6552a8d2952751a725656888d5d765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1edc2d0f7b7d25a124ac82c66fff9f6d657bab78d51f5f26fd885ae455cea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "12903bc5a9839acb8b24f74f62e6f9669be8f50275dd059c369b2ae054f311a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5ba51339da75506af268cd3b69b28d480c5e8b76577579f9f439986c5481ebf"
    sha256 cellar: :any,                 x86_64_linux:  "482a4c9c936629ac708aea78a10e94e47c5c6b7b9de8a309dfaf3d07ab0006fa"
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
