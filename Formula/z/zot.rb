class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "6da4dfd6fcea0a9cc5e8ac93ec0115ad59e1d39ac933d4fcd8a0413c2eed3669"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "185a812adf774cafd43dddbf28bf4b5b51b789909e887ea15091f746bf5ed152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "185a812adf774cafd43dddbf28bf4b5b51b789909e887ea15091f746bf5ed152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "185a812adf774cafd43dddbf28bf4b5b51b789909e887ea15091f746bf5ed152"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbbd3cb350cd560d1dda83cb7520fe0955f8138fc11fb05c264b36b16bd9d2a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564c8cec4e98af5beaa7a041f9bd01be74442e140ca41e510749a1ece16cf53f"
    sha256 cellar: :any,                 x86_64_linux:  "03b9e8c8fee74ae27f7d47bbcaafc4776af6a351d9ab304a8744fd35bf8aa586"
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
