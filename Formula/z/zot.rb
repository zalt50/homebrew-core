class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.49.tar.gz"
  sha256 "01d0c91770d87c5ca11379ed709ba0334f89ddacbab1263b10a71610535a2570"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e9954c252cae10b6ce560fb0a0c78e00ec482bb93e115b494643b9a7ffc2900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e9954c252cae10b6ce560fb0a0c78e00ec482bb93e115b494643b9a7ffc2900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e9954c252cae10b6ce560fb0a0c78e00ec482bb93e115b494643b9a7ffc2900"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb902d8dd69728f860d1e6acad2887c3e154e9739873a83dc0c57b7719873fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b55bb6473bb93eff7d55f2981a25c7212cb7c9601032a515fc495fedcd661266"
    sha256 cellar: :any,                 x86_64_linux:  "e59bc5a931521ddfa39142ec4f090259bd5fdb9884ea32ae050a998424438247"
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
