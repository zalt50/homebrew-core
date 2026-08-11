class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.40.tar.gz"
  sha256 "a63c20bea49e160a9be343c509e2ec2cf4c6eaa531146cd2be09fac0b3c98776"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "889605386b7e88c76a19f818d61599abee8242c21a48540075b98662067a4f40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "889605386b7e88c76a19f818d61599abee8242c21a48540075b98662067a4f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "889605386b7e88c76a19f818d61599abee8242c21a48540075b98662067a4f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "35cfa155467c596b9beae754448e0bb5c19403fc80c0fda05ecd0199af34ce91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7fbb2f6359e24ac122cb60dc4eab814356d65bf8620964e2d82a7f20a08fc30"
    sha256 cellar: :any,                 x86_64_linux:  "b47c01ea091286af37408bfefacb259d66bd2bd58010c5676d6573e236599e4d"
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
