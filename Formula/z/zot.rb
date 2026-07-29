class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "8ee8bd2e0f62c748927dd5f6bba005c6bbe1de79ae091795e48a4d0c64329ae3"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70d3a8e0f5f64996f43f55b2e1d70a4f5cf2859d407090d5872691dc8a49f469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d3a8e0f5f64996f43f55b2e1d70a4f5cf2859d407090d5872691dc8a49f469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d3a8e0f5f64996f43f55b2e1d70a4f5cf2859d407090d5872691dc8a49f469"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e43167d0dd54a5315cdd828b82619e69804d496398fe31e3ff09ad8f4336c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f98a5ccb7647c2f5c3498d2bc3eabdcd8e19b6a51d815692f7c701ed387901da"
    sha256 cellar: :any,                 x86_64_linux:  "a758ec500c9d1f5c3e99d7232644be93f9c4b1e25b621bcc856f6e137eb0a67d"
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
