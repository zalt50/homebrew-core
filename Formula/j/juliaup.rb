class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "65ad0fe38631f035fedcde68f6fb01e9986a7b8c5e6e8945d5c757f3e6663933"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72409ca5a0bef58ae25f9e85e7268f2360e10dec609affbc324917919938da46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9cd0c2a91526eec3466937f2efac6245db1e626d146a7f60d61317e50d9a613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9502db345b551fe094197f5af4af9ac08d7ec29c3586a20375406273fa668f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04c8c1c01b9356025c46915a4b96e332971226035ab47bcf8094d9f9b078d5a"
    sha256 cellar: :any,                 arm64_linux:   "c83c64b0fbb08e8e1012ab158c7fd5dc7f9dc53bfdb97f3069ef6004fb9dc046"
    sha256 cellar: :any,                 x86_64_linux:  "4950d3495fcf97d3d831d7eada875b8b1582b64a47579db7690583543ca824d0"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
