class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.73.tar.gz"
  sha256 "bb2f27f3a5cbc35893602e7bb8923160331f30d5bfb32d87156a0fa7c425b84a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a40c8579a7d0131cf6421af116a766f3f9dfe62ccb89ee937db722e437144df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a40c8579a7d0131cf6421af116a766f3f9dfe62ccb89ee937db722e437144df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a40c8579a7d0131cf6421af116a766f3f9dfe62ccb89ee937db722e437144df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d5e7bea92a3b6085718a8e99c1f60a58301fc1156c78ef6d6bb2419a34d0b95"
    sha256 cellar: :any,                 x86_64_linux:      "5026205d2ad0dcf15acc44c6b29650e45ba013d4f121bbccfc639f95b55252f2"
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
