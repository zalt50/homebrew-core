class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.57.tar.gz"
  sha256 "1800226411e1b39af9b48e850c4078a2a77762ecb74c2422f417a9312aae5d04"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27ed5df699a77b2bcb785a14696b4ffd76139b26c6007368890dfe3caf46dad2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27ed5df699a77b2bcb785a14696b4ffd76139b26c6007368890dfe3caf46dad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27ed5df699a77b2bcb785a14696b4ffd76139b26c6007368890dfe3caf46dad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c996783195627b965976bd506a55e89ed0640db70169cf3981143c0b1806ffdb"
    sha256 cellar: :any,                 x86_64_linux:      "ddb01251ad5fbd7ec45bcc4fe7cc48edfb00b715f146cb5c6b5d29259d2b991e"
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
