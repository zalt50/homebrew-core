class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.34.tar.gz"
  sha256 "a49990e59d6fe5b5939e1b0b214895eefe83ffa17f9a4624132852ab4eb45260"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "596397e1ea0fc942512487749a5f97e40bebca91d3382f4c432371c8bb64fd50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "596397e1ea0fc942512487749a5f97e40bebca91d3382f4c432371c8bb64fd50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "596397e1ea0fc942512487749a5f97e40bebca91d3382f4c432371c8bb64fd50"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e17409c8a2b880430904bbc0631768b626fe2b518489f3566416a1dcd5ac91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55cea5df7bcd0c970709218b36e923f522ff26dfd1fba254e8668ec440f4bb85"
    sha256 cellar: :any,                 x86_64_linux:  "008a7d5edd8c8f24396d9b1a4b5a57c4837e70a329cf656612d2f367a7955dd9"
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
