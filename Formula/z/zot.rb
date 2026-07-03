class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.56.tar.gz"
  sha256 "e96fd20499ae810d8da865ca9a7e6f1f6e24cadf7e89f9b7324d40dad91cffdf"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac6aa44c8ac245c33036b00e98ea96b50800891eb3c43abdf85766dac6b1af06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac6aa44c8ac245c33036b00e98ea96b50800891eb3c43abdf85766dac6b1af06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac6aa44c8ac245c33036b00e98ea96b50800891eb3c43abdf85766dac6b1af06"
    sha256 cellar: :any_skip_relocation, sonoma:        "e66c90430591174fb890a8e7ea0ffd2d4e35c09dd915e1976ce58061a94feb09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3521d4a13ba1e41b4811a8d3a650ae0383f238c653cc7e7a82898197f7da7f2"
    sha256 cellar: :any,                 x86_64_linux:  "2e80cfb308c9fbbe50d1ce09a3afcce70ee0743dd880c504758e571b7898cbcc"
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
