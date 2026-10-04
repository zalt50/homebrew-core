class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "bea13b5b1fea23299c2172caba072c4943f341f2698ec89020557757054bce03"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07490893907b56aeb3f812c1673d98c8f8d8c1e7a19528fdd46be550acf2be77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07490893907b56aeb3f812c1673d98c8f8d8c1e7a19528fdd46be550acf2be77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07490893907b56aeb3f812c1673d98c8f8d8c1e7a19528fdd46be550acf2be77"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e86373135a311e829108604cb11d02ad2fba19797a3043c991f0e8c3efd1227"
    sha256 cellar: :any,                 x86_64_linux:      "571cb86229faece92b897cd0ff6cca4dc4e21d6b12aea45123caee4ba59be7c7"
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
