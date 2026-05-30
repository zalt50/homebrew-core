class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.12.0.tar.gz"
  sha256 "b110622db982795684f60a5ebf67b3d9a805cc5475d45c068b8e877c60158b6d"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "279c7d7a8cb980fea7b25d42880b75df29434521f0f84cca21538f158e5895ab"
    sha256 arm64_sequoia: "40c4cb92c60f3360284b74cf2202d329431fa099d86632c4eeae211a95d4ada6"
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
