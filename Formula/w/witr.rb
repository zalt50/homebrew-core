class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "6338acdd363614d3327e8b4826492b98133748997b43016354a45fa55e799eca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4174ecadff5e868c9c90b1320722f1c196f1a8d132ef82608800f2b192bd606"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4174ecadff5e868c9c90b1320722f1c196f1a8d132ef82608800f2b192bd606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4174ecadff5e868c9c90b1320722f1c196f1a8d132ef82608800f2b192bd606"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b51c489de2aa8ccfe0fd1e18c03ab4244e2648dd0c6625b985aae88f0061cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0702f25924f8776bd9e070d14066fb7e9bd892b7c6a9c583d0730e76e78ddb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ed22980d86c97398e792fadf0ce4c414f80408ea73625f6c70e8a8d5afe736"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end
