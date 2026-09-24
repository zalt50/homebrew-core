class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.90.tar.gz"
  sha256 "f2788378197b2994ecfe0844a420e54eeff5c17a7aedd37a386a02e98536b865"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ddf474f395516423dbbc6a18df722fd0e31dd897e0dba5cccc8f180528259e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ddf474f395516423dbbc6a18df722fd0e31dd897e0dba5cccc8f180528259e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ddf474f395516423dbbc6a18df722fd0e31dd897e0dba5cccc8f180528259e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4cee26f286ea7395e994987a467591bb3889c557c90901c9d1141c471e5010b"
    sha256 cellar: :any,                 x86_64_linux:      "3e810c191391cf32d6c56d3c621fcba115a65d78e9c7b884a125b220280f7397"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
