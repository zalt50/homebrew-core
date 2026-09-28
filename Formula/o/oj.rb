class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.7.tar.gz"
  sha256 "13eb1f62ff75ba7babaeadf182008d0919fb8332836a6b5b2b96f1aa591cb0cb"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49377d13e1ce73e4dedd58984d8339a70aed25277532225962d6d92fb219ef8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49377d13e1ce73e4dedd58984d8339a70aed25277532225962d6d92fb219ef8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49377d13e1ce73e4dedd58984d8339a70aed25277532225962d6d92fb219ef8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "49377d13e1ce73e4dedd58984d8339a70aed25277532225962d6d92fb219ef8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbc6309295210482c4d7705ca6b54439eec79ed34908083f04055207c6c452dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "881192b21aeff2b77cedcef4817a31df380da8b75606b9f677cb152faa10b07d"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
