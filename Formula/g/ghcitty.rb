class Ghcitty < Formula
  desc "Fast, friendly GHCi"
  homepage "https://github.com/mattlianje/ghcitty"
  url "https://github.com/mattlianje/ghcitty/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2764c26ca4bece4c2d404ad805604029a0ba047d8075d4d13a108fa7e6156623"
  license "Apache-2.0"
  head "https://github.com/mattlianje/ghcitty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97d54da8b7240fb28913190e8298b363381c4e596abdaea7e9c173bdfb6a1557"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3c52753aba1e890d588d6015b196921c633118e3cda54f0fe328bc553b7f846"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4edbde42a5d4e1af6c281b1ba3f181c5996eda93f5e5aa71285940be3af5fdb6"
    sha256 cellar: :any,                 arm64_linux:       "2a23483711f55b9d4d7a0142d15b5100749dd54a60c9daf7591010dd91413525"
    sha256 cellar: :any,                 x86_64_linux:      "6fb6326c88700bf7133a0faaf19f8dafe72119f57cd6060686344ba8c8c859e4"
  end

  depends_on "rust" => :build
  depends_on "ghc" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghcitty --version")

    assert_match "[1, 4, 9]", shell_output("#{bin}/ghcitty eval \"map (^2) [1, 2, 3]\"")
  end
end
