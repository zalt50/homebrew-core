class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.51.tar.gz"
  sha256 "13be5745c6d35f012b9564ae547cd46238d7f60f1ff94d2bb0bdfb100aabc2e9"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7564fe5637451933b867c0b6722aea18b9d0d25e9e2e8e4b3ce973f3f28ead52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7564fe5637451933b867c0b6722aea18b9d0d25e9e2e8e4b3ce973f3f28ead52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7564fe5637451933b867c0b6722aea18b9d0d25e9e2e8e4b3ce973f3f28ead52"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c294ddbf60f8b4c7ea06472acffd343e40606855d908c70d1c26bfbdab88d9a9"
    sha256 cellar: :any,                 x86_64_linux:      "92cf42b164b756d12af889a5119603010fe5f24f006707925e753856cc82d24e"
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
