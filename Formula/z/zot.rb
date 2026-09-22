class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.85.tar.gz"
  sha256 "00068ee859bd2c95c54190add3d56178b5d05bfcd70af5bb7ac0678507123da1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5a9981b6024c3413a417a94a0b0efcd55dc0c3ac1991371eb39e9c250743d89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5a9981b6024c3413a417a94a0b0efcd55dc0c3ac1991371eb39e9c250743d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5a9981b6024c3413a417a94a0b0efcd55dc0c3ac1991371eb39e9c250743d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a2b63b48deb77086b9c7c33c0203bc1d687cf70afc057abf76a4f96d6179ccd"
    sha256 cellar: :any,                 x86_64_linux:      "a53609cc09f140815d9d3366c7e7174f869da1ad72819416c5f85ab3f52c2820"
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
