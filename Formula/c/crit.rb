class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "704d18b542370cb29e358091a0dc04bbfe8e26b717e5ed3f42ad13d9af8475f5"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6d44c5dce5e5a2bd76206b5fe81aa3c6d03a922b9bd6aa670ad5210a8cc0de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6d44c5dce5e5a2bd76206b5fe81aa3c6d03a922b9bd6aa670ad5210a8cc0de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d44c5dce5e5a2bd76206b5fe81aa3c6d03a922b9bd6aa670ad5210a8cc0de7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d30e6bee8454782bcf1a73edd7713bb8afc76d57151cd9481fa6c375b2eb72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9417e91b9bb90a7e2d47ee2022bd358e357da4ad739dcf3ce69718a05ce60cd6"
    sha256 cellar: :any,                 x86_64_linux:  "ea034fb23e3cf03e8820468bc2a57f4e9caff9dc6fbfe1b58953d565ff00b944"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    ENV["HOME"] = testpath
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    review = (testpath/".crit/review.json").read
    assert_match "looks good", review
    assert_match "hello.md", review
  end
end
