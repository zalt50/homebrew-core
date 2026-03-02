class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "6a889718563dd3fbcccb49684acb628a9d3edb1f0e00dcb66502e2ee76c69f60"
  license "MIT"
  head "https://github.com/mroth/scmpuff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cd803fd3930682c127f9abe30cf15fd2c669689a63591e6a092f910e757a37a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd803fd3930682c127f9abe30cf15fd2c669689a63591e6a092f910e757a37a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cd803fd3930682c127f9abe30cf15fd2c669689a63591e6a092f910e757a37a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa96baddca0819d0381f6bb05c5ae54bed66f00804db6f778cb93ffe4a381cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab36d84c0f8b218b9cf7ca1aec1bf695aee059285aa163ac854a0c05b3b24c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4308a8b0b1dbdc20f970ce80475bcc16248bab5bcc9f1bc98bf276aa83a4f20d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scmpuff --version 2>&1")

    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
