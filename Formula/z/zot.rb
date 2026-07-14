class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.84.tar.gz"
  sha256 "fb480412168ef0e054d5e40a915c500160b20c8800200d7875a01d1e67cc74f4"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4070e182820feece72fb5107706a1921d64a5f1cdb07e2dceb795c54370956f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4070e182820feece72fb5107706a1921d64a5f1cdb07e2dceb795c54370956f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4070e182820feece72fb5107706a1921d64a5f1cdb07e2dceb795c54370956f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "64cad0e013f8fcdec1c7989882c2e7bf62f68432bf233ae45769e996b267c6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b432c6886cd44a4b8562afe923e20878765dd114e5184f95dd5b28bb3a31e4a"
    sha256 cellar: :any,                 x86_64_linux:  "164f024848906ef03bf45392453eab267319dacf10064771e123b0c0c264d6a6"
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
