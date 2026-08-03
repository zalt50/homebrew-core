class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.32.tar.gz"
  sha256 "6f03780129bb44c3fbcb2f521f102fe4b7c4ae68c68ca26f819d8aa2a7c0a90f"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea3fe7da8bd682f8a55bf45a82cc51e332a264feb05b0e3203f520ea250eeca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3fe7da8bd682f8a55bf45a82cc51e332a264feb05b0e3203f520ea250eeca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3fe7da8bd682f8a55bf45a82cc51e332a264feb05b0e3203f520ea250eeca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e28874f6a330e996dbf57f4c75f8bddaffd13ac247f88e3344722770a055414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb25690386ad7e25e42ebc5b5d10d60a4a4cef0ffb1f49a38e5cecb6f9674b4"
    sha256 cellar: :any,                 x86_64_linux:  "f36a2f9d3400dc4bbd0102e2032816a91c331b8c94d86a9c13b5422623d96717"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
