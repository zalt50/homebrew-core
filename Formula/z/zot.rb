class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "9b64a0124e3498c88376c8f01878fe64c441b4ec77c7ce1041118ab532cb5f02"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bbf2baf725184670dea03c32f46e01bbbddcb0cbbc2f23826a9b7301d6eda7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bbf2baf725184670dea03c32f46e01bbbddcb0cbbc2f23826a9b7301d6eda7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7bbf2baf725184670dea03c32f46e01bbbddcb0cbbc2f23826a9b7301d6eda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9e71c6a7464b097fbe5b40c1ee6f001052965d633727e69a4fa457c8f6be06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d6ba420099fdf042736db9703b5285298b2acb8503e2fb4c5ab8f9629ae156"
    sha256 cellar: :any,                 x86_64_linux:  "684a770243278e9a9476ec1b2d79497497ccdcbb19a4f0905148706aec8b2020"
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
