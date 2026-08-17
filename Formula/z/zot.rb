class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.45.tar.gz"
  sha256 "e2906caea8ef196e292e880d7680b6c39f0ba594f1ca65654ace7a2c692dec57"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d19e8ff528e9133c0cf38d8fb2a6135ae516902308613c165e25a53ad52fbaf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19e8ff528e9133c0cf38d8fb2a6135ae516902308613c165e25a53ad52fbaf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d19e8ff528e9133c0cf38d8fb2a6135ae516902308613c165e25a53ad52fbaf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1808e2018f62bc3bf41a506a959b638f83aa52b2a937a3dac6570fc43b8bd14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295c9fdc5c7246bb088643b7a372b90a662bd207be4ff1d3b092fca38f080b43"
    sha256 cellar: :any,                 x86_64_linux:  "4e20b852f95c7cee4da397b0793e0cdeadf1f5f8db05f91dc7bfaf2b56aa75e4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
