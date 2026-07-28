class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "ddef3b9ce25d984277631ed802f8c23f210b88c4c02336ed2cb352eeb4cba44b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35f17717907bfa41fb778691f825fed930b48e9b8100546f42555f87add76ef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35f17717907bfa41fb778691f825fed930b48e9b8100546f42555f87add76ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f17717907bfa41fb778691f825fed930b48e9b8100546f42555f87add76ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "310e97366851b881d34372e5378b11bd6c72df9c2dcb72bcde2327acef941d4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f107c63eb5f5b89abd54be7d2f5e50008d35c0c922439c668fc96da098189e3b"
    sha256 cellar: :any,                 x86_64_linux:  "4c044b0d59ff13661af3768fa8ab8480255937f54e83c8aa7d1d7ee4a5d19423"
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
