class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "1eeb0dfddbf2e5b1a850e24ea5ce9bd7681501b1d200e26fb5e3be465337c1bb"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e82d8fd37b04b7d510883fbf2bc812516834d0d263b3a4b577754ac46c3f643"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d540b4b0d05d83aaeddc95b5bd00920bd5475fb7adeb5f99517b1109ef245b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec842a659e336ece1a3896d177d78966f4db801f147fdfc0f83c8005f00ad48b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a5b52f770f3747692e9eaa11d68f89e4b7c51f662c62a673875fbd453639692"
    sha256 cellar: :any,                 arm64_linux:   "e08f5f7e81c429fae7cc974bb167d5a3ca7a381b5f5c754dd8a580b92c2de961"
    sha256 cellar: :any,                 x86_64_linux:  "84bc6430bf10ce4aab944cff5c2352399413f1d356be751b812d4e2aa0afe372"
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

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
