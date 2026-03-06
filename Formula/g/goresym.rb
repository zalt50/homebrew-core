class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.3.tar.gz"
  sha256 "e0afe3faaf824460b611a1ef6e93015341cfea999a6237516c15b59f8936d3f0"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92a9cbd4568cf0c24b7efd08925d682b9d97979b979fd37df7b647df74dc32f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a9cbd4568cf0c24b7efd08925d682b9d97979b979fd37df7b647df74dc32f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a9cbd4568cf0c24b7efd08925d682b9d97979b979fd37df7b647df74dc32f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58f83dcafdeb17f8674276892c7d236c17c7331781ea2d1137da341e67dc1f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93acb0e2901d05130ed6e59a711a69ea593f938511817e3b26e055bf29b4a6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f5ae6ccbca1ed390f82e8d67ccf1f8b4a2ca4ead1bf066dc275e6d38c1d14d9"
  end

  # Unpin Go when GoReSym supports Go 1.26, ref: https://github.com/mandiant/GoReSym/issues/80
  depends_on "go@1.25" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
