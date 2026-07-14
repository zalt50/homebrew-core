class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.85.tar.gz"
  sha256 "b8f3f4c27a5129712c20cd6841a52af8524377643e6f8938c9f920dfe310ad87"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e13934b2feed3f61c341277d87a166a4f8648c02769c3b583841fa9f133040a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e13934b2feed3f61c341277d87a166a4f8648c02769c3b583841fa9f133040a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e13934b2feed3f61c341277d87a166a4f8648c02769c3b583841fa9f133040a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "993d3ca768db9cbc67aae697fb97a7150807e5498b36183ce0a4f50222cf3105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38dc6336ab513f80a03e8adced7cbfdd77c2ae852e1ef0a52625c13b0feef2e0"
    sha256 cellar: :any,                 x86_64_linux:  "c639596cc66697f97d5e88a15cfde23da4bf6272d781f5d5d6a767a9534f0a3d"
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
