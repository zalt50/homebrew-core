class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "40a14d3799380d01b938883f8158d7a2121e8ccb4466e5ac531e98c827d1e325"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6730e6baafe56d2fa1221711167f9396e6d0db80556e48ebcfaf7c05c30cff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3380300fea9e025236a92e3c5553b58e219b9de51d0f3b3ff04ffcc35c97d1e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df1b80a00e9504d08112aa834e3988dcd7197ecc0a655bd6a18da927f1903a72"
    sha256 cellar: :any_skip_relocation, sonoma:        "76203cc3f4e5743cee6e17a5f7d4028636e73696426f1b8abb7323ae77df2737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "851e88cd6f9773478ba6ae43d655515faea9d23d0cb4fb65c8f2eabc7ac1e431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e98519c8661ddb52b1350effbbd0a20833de5b2925ce4e5fb3ad7539b4ba62ed"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "goose Locations", shell_output("#{bin}/goose info")
  end
end
