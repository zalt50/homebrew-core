class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "635047b0103874934c840184d42b27b5a5076550ba3f26f55f2cb71a1cec485a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f7dad3fd7273d97e5117b005dc39738eb0c6c89c4df66bddcb8a240d90965b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f7dad3fd7273d97e5117b005dc39738eb0c6c89c4df66bddcb8a240d90965b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7dad3fd7273d97e5117b005dc39738eb0c6c89c4df66bddcb8a240d90965b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2c2262277f320ca3cd99b8bba6358c34629023a65997d68e4c41bf760374b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6308310ea015f7b82255b716ef088043529e4441eaf208bbe11a170d33733f14"
    sha256 cellar: :any,                 x86_64_linux:  "fcfc048971d2de2c694657986df1be4c118edea6a3f05a0815f0eab38745bdee"
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
