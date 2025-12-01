class Matcha < Formula
  desc "Daily digest generator for your RSS feeds"
  homepage "https://github.com/piqoni/matcha"
  url "https://github.com/piqoni/matcha/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "239f97bed3014c8809d3d70c7840b77985c7cd12dc73510ae7a2fe3f557a0e1d"
  license "MIT"
  head "https://github.com/piqoni/matcha.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Hacker News: Best", shell_output("#{bin}/matcha -t")
  end
end
