class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.94.tar.gz"
  sha256 "47f6da770c3d5d1d32c7c06df10b348e62121274f932fe44fe21f11ab57e8a54"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86873fffeb8950b2d9791ee991c13b6298072382df4eda58301e6430b3bdce69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86873fffeb8950b2d9791ee991c13b6298072382df4eda58301e6430b3bdce69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86873fffeb8950b2d9791ee991c13b6298072382df4eda58301e6430b3bdce69"
    sha256 cellar: :any_skip_relocation, sonoma:        "4655b39fe9044f9c4cf477f7c5db9555f83b312fb767384bf143c3be31cb112c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7207a68b0909a505d764e13100d05cc9f2747305baf2cdc0b359d01214165e"
    sha256 cellar: :any,                 x86_64_linux:  "5c6bb591de97d465a27fc12f2e1b22080c9f386a8f5b6eedab6249587555d804"
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
