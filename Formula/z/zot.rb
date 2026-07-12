class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.79.tar.gz"
  sha256 "d3526af2ac5a2b57621a273d7b5c3a2eade6b4085d2b01636145a5d73a63bd4b"
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
