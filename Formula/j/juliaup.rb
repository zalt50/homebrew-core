class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.9.tar.gz"
  sha256 "d1b98511bd0e7c9fda9bb43f97de58237f3f5cd8cc2d98da7a8b7390276f122e"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "278ac7b58bfb3bcd9b13c9226548a79222375ef6341ff461d8091e3829d38a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b59d9b288e0ffb38b837482bba00affed50d5cc8cfc8ce4f4eb91f9014cb3c05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68152e7a22b9435eb17d364743d4ba98f72a308cbe652a177a9a44f3f1b61096"
    sha256 cellar: :any_skip_relocation, sonoma:        "5642ab740b8fd1218593c90db799397ba39fbcedef20a48281d506db3ef3e505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b43933c6a67d98dfc453d9e9d99ec80f7dadc22fef2091dd801c0fd296adab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e3a4f8418707ae02632fb0ec0d6dee21b1942f7889f167b07a9bd775a153e85"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
