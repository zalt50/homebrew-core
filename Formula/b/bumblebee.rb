class Bumblebee < Formula
  desc "Read-only developer endpoint scanner for supply-chain exposure"
  homepage "https://github.com/perplexityai/bumblebee"
  url "https://github.com/perplexityai/bumblebee/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "559a5fa9ca48128fb113644e7800048b0b6c2ff3a33bc56fe5236582ba1686b0"
  license "Apache-2.0"
  head "https://github.com/perplexityai/bumblebee.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bumblebee"
    pkgshare.install "threat_intel"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumblebee version")
    assert_match "selftest OK", shell_output("#{bin}/bumblebee selftest")
  end
end
