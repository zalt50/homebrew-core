class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "e14600108724dabdd0a0e6da8e8ab1dbf65cc07bc06ff9c1dbdba74fc3b1b29d"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86aa59336ed0d66f429d404ece0bac9755c9fe3a51565c7a6559c25eee1eac75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86aa59336ed0d66f429d404ece0bac9755c9fe3a51565c7a6559c25eee1eac75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86aa59336ed0d66f429d404ece0bac9755c9fe3a51565c7a6559c25eee1eac75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed01761c3b2cf88b2cc2eee20d1b72e70af3fbf2e3b35a716e33b98b273a847a"
    sha256 cellar: :any,                 x86_64_linux:      "f58f2135c5e34f9ffbf5206620554f4e7482aa5b35160147743d121d04b5fd26"
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
