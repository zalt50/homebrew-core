class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.5.tar.gz"
  sha256 "e6be148456e8f75eb2d22cba7d65f12201f66ea8bb5afb6bdefe8b68292b3755"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e58eb8d827b2a7b09d14f35bf90d30de6b9f44c86d6c2b48379c55ddfe516812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58eb8d827b2a7b09d14f35bf90d30de6b9f44c86d6c2b48379c55ddfe516812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e58eb8d827b2a7b09d14f35bf90d30de6b9f44c86d6c2b48379c55ddfe516812"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8eb356c3e0e2eccfdb3b328142d7613f437a4cc18640df045953c6da0400706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bf9fe7bd5ee246a3d03662067dcca995959ac129a240015633e1cb9a2fad1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ed728f1f5f863f80c5a191d7c1763473eb8e1aa28a964309abe5c9ca36f4f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
