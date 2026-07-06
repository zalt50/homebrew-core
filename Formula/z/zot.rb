class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.63.tar.gz"
  sha256 "742135546adf5e0e436138d866963495537f4223a011aba7f33f1b29a4b7d5c8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a7bbb5751d0d8d874610a050caef8653b0fd752d0e43884f2b52e3e9ed6626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4ac69a93ac5c81bef2cf211db8de0c8301de42ba28f7e89ca1cb81c8179c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7523d5ecaa77aa3946662e118771d7cadfb251d8055f0fa169dfa4a71afc829"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d533087ae80fa49d2a2ed9ff08e69c21d7ca6af6ade0552a0cd883bcf62654a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61743bd2cb7fcada2d28607609726cc61ef60c9483372de43690c0f3bd5d34a4"
    sha256 cellar: :any,                 x86_64_linux:  "2fae7869ed5c460cd38141c8620ebb563b5ae3ae08123f7a185cb6c3b91bfaee"
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
