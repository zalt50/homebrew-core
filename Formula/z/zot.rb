class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "3345d2a652414ad6069729fd4fe3d897823511fd0f6800b7ffadcff500f9b0d2"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86a2ad13bc74f1d7070450927326745d3d297b4ed4ab5cde54bf4ed6995f1e51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a2ad13bc74f1d7070450927326745d3d297b4ed4ab5cde54bf4ed6995f1e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86a2ad13bc74f1d7070450927326745d3d297b4ed4ab5cde54bf4ed6995f1e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e09889f5bc07d0f4c144d3e07fcaf1bca1282e7b2a58617c889f4dde2757ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d1c39973ca1e8f06263f509d906dd64c487015ebf4ad3280ac81251ccf7536"
    sha256 cellar: :any,                 x86_64_linux:  "be34fd8c50dca5b3a2bd9ad75a86d5fd46866eecd1cfea4af427a867ae25f470"
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
