class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.74.tar.gz"
  sha256 "ad3ca67ea6c61952b948ceaccb5fb95994ff46361d31aa36f3aeadf8bca5656c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bb51a6032562ba5fa3880772c3e3400a41f7ab336340f0d1859e525ef4df236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb51a6032562ba5fa3880772c3e3400a41f7ab336340f0d1859e525ef4df236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bb51a6032562ba5fa3880772c3e3400a41f7ab336340f0d1859e525ef4df236"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b6cff1161e8eba25294c1aebbf7de30843a5190b43a4e220d90b86ce1db52a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac191f1e3f8334b91a913b64c2f16a0a49125642692ed3b0a0fdf1e9500866d9"
    sha256 cellar: :any,                 x86_64_linux:  "a7f7b323d7bd85a89ed55a35f51ccaa75a8487b9cfa96b14e51799acc9ad6bc9"
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
