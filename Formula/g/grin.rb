class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "841a698986ff05768c6d7cdf2e59d44571533522fbcffdab0a0de01c8de1d4a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cde526298dcfda7cecf676289b5f0dedd0fb49ac338e5f0242375bc81172710c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045d74884249365444eecaeb74c3402510e4ec83f4e5661f4ad7673354cda6b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f74512cc0b2056c5947ea527ca7ec9717c6f81a1f015c924191802f9ead9aed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a662a351948f1185dc98ae0883ce35f9618bf72d19e5fd002a46c59ef78c9b8"
    sha256 cellar: :any,                 arm64_linux:   "811bd78d6d2cc00eb4215193bf53e8e50b6ec445ab1a7a6b2ce6323d4d189962"
    sha256 cellar: :any,                 x86_64_linux:  "05b94cc04ff3af753acc4bcf88605b6147919330d185dea75d780286383db84f"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_path_exists testpath/"grin-server.toml"
  end
end
