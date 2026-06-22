class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "4af6be157e99cfda4f7296ba3a018a9ee8bd4c2ebc5057f248a5a6021c1081b1"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "662cc5337ba0ef6dd086306970f586c328e87d318cc132411285d340e52c4984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "662cc5337ba0ef6dd086306970f586c328e87d318cc132411285d340e52c4984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662cc5337ba0ef6dd086306970f586c328e87d318cc132411285d340e52c4984"
    sha256 cellar: :any_skip_relocation, sonoma:        "77df7bb23d81a6a729eafacacaf39f34d19b80201eaddbe66f23ba6b01e41d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773064db086b473b845362442e473d38b41d21de233f346c0fe360bcdbc8ad07"
    sha256 cellar: :any,                 x86_64_linux:  "6c3d11c1f031626706d18f72cee5ae4dd1bbadea3c8855a0d299c057c7627e44"
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
