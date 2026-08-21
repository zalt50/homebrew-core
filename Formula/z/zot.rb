class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.46.tar.gz"
  sha256 "ae8c6fa2689af80b045d9b8fb8f12a3da4a1612689586915eb8e5e1d51bcd1bb"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed657a8869792e9c8cc211116a4ed43b069d68d41037de87638eba5abebcf3f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed657a8869792e9c8cc211116a4ed43b069d68d41037de87638eba5abebcf3f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed657a8869792e9c8cc211116a4ed43b069d68d41037de87638eba5abebcf3f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ea0b7600032aa045360a51060646c8169b4fb56199c031a92e4bf466a37444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e292c1264c6a30cf2984352236741762259d85a4d2fffd1fb83ddab08b1692"
    sha256 cellar: :any,                 x86_64_linux:  "abc7eda047d020b3ffba066ed61b81e4fbf24f0ca0da3a33e8c3e0b666e1fceb"
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
