class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "499a86d97180b942091095afa0aa7dc1c77e09d03a326ec2c078579dfe47d765"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d4b82d54c2ad28bc055a4928bfafa55e161a8a2ba56d24f9652ccdbe5eab9f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4b82d54c2ad28bc055a4928bfafa55e161a8a2ba56d24f9652ccdbe5eab9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d4b82d54c2ad28bc055a4928bfafa55e161a8a2ba56d24f9652ccdbe5eab9f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88d80c8af2e09a21f2b6dd976138365cf3e6f44bdf8925e272fda95330d83e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4eddaf514e3e2cc1eb096d6511c556b15444dc914359f7f83c90e17e448f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712fc1c07494f012a1db50a300cbb1b31194a11fbf56c0703e04960ec6cb2cf4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
