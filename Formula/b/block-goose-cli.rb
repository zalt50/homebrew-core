class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "c93de05254070ffd4c19f4ea3f22c2d7ca551888154addef773d4c56f67561d7"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6244254f9a3c98f1f20b03540d24dc11b568c05d3a43df839b543347b7f0529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f76af5924e3f2360950f95eeb48bb5b48f8dd4eedc345222a20e830ed0e41f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843fd70d5d05448e59ffd1ef008acba0b7766cc8888d9f5919d16441250f490c"
    sha256 cellar: :any_skip_relocation, sonoma:        "12fe6c788ce419e673d447cd779af58deb0025c5b728d1fb9a7e5ad22b71dde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25a6b9bb13a5aa0be6189449a84cf8fde7db4279a9997332c9b8fb4ae428991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f036a6f25825fbf6808181e845a2a2320252e5bbe0449c5b75e5658740779340"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
