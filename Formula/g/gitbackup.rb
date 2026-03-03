class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/refs/tags/v1.1.tar.gz"
  sha256 "b42949c3f4f273651e67e5bf935b6e0393f8553da2ea54a18bca0253960104f0"
  license "MIT"
  head "https://github.com/amitsaha/gitbackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "035d6e8ca3692824a3965463833a31867fa797234b2112a90fe554e6ce637fe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "035d6e8ca3692824a3965463833a31867fa797234b2112a90fe554e6ce637fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "035d6e8ca3692824a3965463833a31867fa797234b2112a90fe554e6ce637fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f21c1d5aadfb422a874c6b82b3236ed8d66c809fb3bd0f25347939839d3ab34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb2ac710f7d0f399024870f884ce85cde2e451ffa8fb9e60420b3f801463b984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1759d3ec6f3b9c816f6dacf36e3a7939a0fb93dc0722a0b40c0e07a9273a1e01"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
