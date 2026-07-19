class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.38.tar.gz"
  sha256 "75e1100e3f6308dc5934f37d4a0f45cee0b7d2bdb97e88f9ae606fbb639da0f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "58070b0f57511d444262d478895dde9cd44eab06d984a4cb4a43b852e4665559"
    sha256               arm64_sequoia: "c128a006825a31d8a953d92a62feb4b2eeed0c7fdc678a2d31f3c8a11e0067fc"
    sha256               arm64_sonoma:  "407eb1932ac183caf15718726391eceee924057c31eb7107c3545fe305868f0c"
    sha256               sonoma:        "9ee5f23a73d818c17171c34c0289a37ca4a58a8b1cf52e138c1814b8ea10de73"
    sha256 cellar: :any, arm64_linux:   "ce6530f7536d632e576d80e99ae5293b74943c202903e1d4e0906ff716b68309"
    sha256 cellar: :any, x86_64_linux:  "d95b6eb6b46fb84649e15c66e594f795edd341b05a25f7a1b8a4eae675fe4c1c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
