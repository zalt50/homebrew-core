class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.80.tar.gz"
  sha256 "5f9a12e0943619ca88336097ce8d4bbb5476dcf97bf66d95d0b6aafc46db2698"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb2d8824d3a459ff6bdc429eea3c1089ca5a00c4f074894613b91e1005410e70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb2d8824d3a459ff6bdc429eea3c1089ca5a00c4f074894613b91e1005410e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb2d8824d3a459ff6bdc429eea3c1089ca5a00c4f074894613b91e1005410e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7375bc013de7f4bb643bcce176d5b3ed8f13514428a69f4da3896506d080fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dc14bc03e22421011ff0609b82a0f79a9ce78c93966048c25e813fedb24a5b8"
    sha256 cellar: :any,                 x86_64_linux:  "2b95e3c35c00ee92290d273ce1129e9ceb1ac8bc59b07675cdd08a963b9aaa70"
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
