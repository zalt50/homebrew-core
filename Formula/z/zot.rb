class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "ef658e8aa0447b6c976ce346c5cdaf883a70827b96c2d1c40099991be0e69d26"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be6fa43c5491a6f8b8f61aa6133924f704b41611a04a0e7dbf3734ef9e4acd85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6fa43c5491a6f8b8f61aa6133924f704b41611a04a0e7dbf3734ef9e4acd85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6fa43c5491a6f8b8f61aa6133924f704b41611a04a0e7dbf3734ef9e4acd85"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3606d82b10c1717f17269d270b8605adabbd7d6d646b79938f2eeba12be2a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24044ee928f06f8274373d67f0c61492c360e39532aecc1828d10b7aa9970ce1"
    sha256 cellar: :any,                 x86_64_linux:  "388ff22adcdc5dcbabab8556336f6a1a8c7b4060c10d93b8a21c49c71df3252f"
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
