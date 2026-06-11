class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/1.0.0.tar.gz"
  sha256 "3b31038f6ced86ce207d384112378b0d57d1882bd6d34cae5684cd06a9169d83"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "b3e57ee6f91e91cce2972b51c4a1150f8368e35b77ed9ad2165a28f831ba1f06"
    sha256 arm64_sequoia: "e31ad1307f6d8d36a6b4a6897b9d1a4b380eaae77e6f75c8fc44809ebbc4dbc9"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/container-compose"
  end

  test do
    output = shell_output("#{bin}/container-compose down 2>&1", 1)
    assert_match "compose.yml not found at #{testpath}", output
  end
end
