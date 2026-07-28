class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "2c18dca88efd4d2d6a675cc5e9cb1f10888fcd30de524c35363b8a85209f113c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e0c0255a503a2f09eceadaeca4795a2262a2b7b0f26889f43c23c0181e5999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e0c0255a503a2f09eceadaeca4795a2262a2b7b0f26889f43c23c0181e5999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e0c0255a503a2f09eceadaeca4795a2262a2b7b0f26889f43c23c0181e5999"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa58b479a6acbacf5bec4f93e1f990e5bc9c9bc3bf8b43d4d981eeb27f04c1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ed5473c120d03031f44853f476b81e2f2ac141977d9f2083b6a17e0238f5e34"
    sha256 cellar: :any,                 x86_64_linux:  "8110c4d06e4ce8a3f60968bf7e543060ddf4af9d3468e6a27d50113dc50e6617"
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
