class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.68.tar.gz"
  sha256 "2904615f4e500f3e081f796a195c4ab89afa2ff2f0470f4af47f879641be30cc"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f22025472d8c9513fe4d78076f58c97ea0aaceb00e569c9230b465d2c381e8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f22025472d8c9513fe4d78076f58c97ea0aaceb00e569c9230b465d2c381e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f22025472d8c9513fe4d78076f58c97ea0aaceb00e569c9230b465d2c381e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5089da16109b4507f3ef3a41fb21d8fd4bf9ced55d12d806f1213393a1b6720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b712afad48e63b8f9daa6792251c4e27dc4b27e989294b56677a68a504265cc"
    sha256 cellar: :any,                 x86_64_linux:  "71bb7a99bbd78f69675ea5467a37b268d4f78a249276c195fabfcf3d22c4a7ef"
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
