class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.37.tar.gz"
  sha256 "666b7415495e0219cc851572eee560d09f1dbeeaa062cb2265d513a095ad3dea"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3169902657765248fd768547e9b51d4754a015cc2942e0fecad211f9b9994232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3169902657765248fd768547e9b51d4754a015cc2942e0fecad211f9b9994232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3169902657765248fd768547e9b51d4754a015cc2942e0fecad211f9b9994232"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a77e46de621199eafda8e0292e77b165b23d273e7c9d587542f9338198fa4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "648b714edc81ab69556daece635e14bce2673a6ca3b09997d78c4f6a3affb48a"
    sha256 cellar: :any,                 x86_64_linux:  "73052943b8dd56bae2ff2644c04f15d7f79d0e062a418a5fb9d3e1f7995b59e1"
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
