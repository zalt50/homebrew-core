class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.45.tar.gz"
  sha256 "a5de3e7bd548c6608bc45d4f32055be1b2bbe968a83df2eb7e7aeeb8d470e276"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8188f570fa49f899bdc4d60802f30d16454eb68bb8ee6f90c418ff5843ba91f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8188f570fa49f899bdc4d60802f30d16454eb68bb8ee6f90c418ff5843ba91f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8188f570fa49f899bdc4d60802f30d16454eb68bb8ee6f90c418ff5843ba91f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea527379575c42f572174bc568eb0b114c4c3c883667c643e9b17b14b5f66bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69f6a9685c9c490eccd0ab64dddf204bec67054ca0590a31e3be8497d2ca2bd"
    sha256 cellar: :any,                 x86_64_linux:  "30fbc7cbaccc0e6f5d1182701d14e67c1369dd04f0e21130714d884bebf11878"
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
