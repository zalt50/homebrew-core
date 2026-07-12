class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.79.tar.gz"
  sha256 "d3526af2ac5a2b57621a273d7b5c3a2eade6b4085d2b01636145a5d73a63bd4b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ced3deb9495d97f2f3a9a1333af7665993a8939a6c760501be738f0ece974f51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ced3deb9495d97f2f3a9a1333af7665993a8939a6c760501be738f0ece974f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced3deb9495d97f2f3a9a1333af7665993a8939a6c760501be738f0ece974f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eac6b7740f875423a6f75db41adac080d25678ca71c98f5e8271a13473c2b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb11a0e2cd1019cc3328c3fd174257e5144c95cb35450247ec13baaee90402f8"
    sha256 cellar: :any,                 x86_64_linux:  "1c4e15f09ad812a63015420a70b7292de5a52fa7b52bf540c3d963629ba9596c"
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
