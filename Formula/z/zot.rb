class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.33.tar.gz"
  sha256 "988a5e07e52940224c0216014d79f2094aa66d183bd69599cbe1a47d1e2e00df"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32c17707076c039f3aaef003113ae692ee356cd4fd8ad738bd2d10ebaeae3674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c17707076c039f3aaef003113ae692ee356cd4fd8ad738bd2d10ebaeae3674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c17707076c039f3aaef003113ae692ee356cd4fd8ad738bd2d10ebaeae3674"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6f12e982212fbf57fc70f3d8b7d718f802f1170dc46a5f221120b529157d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22433833346363a09edf7ce32db0dee37803fa53b7ef2e24a91d981108ab4662"
    sha256 cellar: :any,                 x86_64_linux:  "e347707d741dc0a524933f60a02d92a6fa9648b565ec3d303fe6b2d92621bf54"
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
