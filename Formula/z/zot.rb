class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.82.tar.gz"
  sha256 "1d3de88802cb08491a1638aeb710a78024048756c0399bed6294c41f9ca987f1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a1e32cb00f5cccd3ea8e4f452ed75c087f430bbc1d50ee650d1c40d3c608590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a1e32cb00f5cccd3ea8e4f452ed75c087f430bbc1d50ee650d1c40d3c608590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1e32cb00f5cccd3ea8e4f452ed75c087f430bbc1d50ee650d1c40d3c608590"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8851c7023f02e4b3da76e680f5d0d2639bc6afe9b5949e49def2f7e64b9777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aad795969d6f329ed1d6a0b33336a6c5e801e5a0d57659b153c23a7e82c06f4"
    sha256 cellar: :any,                 x86_64_linux:  "0013175b8d4b8015f84c842be8aa3dd7bfb630888ab2a990f4f6656321f86493"
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
