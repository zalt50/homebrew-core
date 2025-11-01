class HackBrowserData < Formula
  desc "Command-line tool for decrypting and exporting browser data"
  homepage "https://github.com/moonD4rk/HackBrowserData"
  url "https://github.com/moonD4rk/HackBrowserData/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "3e4d70e0b6a1b0bc1e55d6caf1a5b8e84c1115f381aa14b382b358a01eb3b30c"
  license "MIT"
  head "https://github.com/moonD4rk/HackBrowserData.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/hack-browser-data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hack-browser-data --version")

    output = shell_output("#{bin}/hack-browser-data -b chrome -f json --dir #{testpath}/results 2>&1")
    assert_match "find browser failed, profile folder does not exist", output
  end
end
