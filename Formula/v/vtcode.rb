class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.35.19.crate"
  sha256 "cc27d2b9088ebbbd9afa839fa4ec4ef429ebe0beb6439df7a38babeb4b363ec1"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f79b852b2f168e7eba2f921696c4696f6e17d6586f5f55d1f136c2d94f51d3a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2265f9a897ef4d96a8dde08480819c7031806965ae545bedea1205e514d1bf44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f47ffb5aba293258dbf231ad77d84219fe2d82f5b7b38b26ad14a79938d172"
    sha256 cellar: :any_skip_relocation, sonoma:        "322f5be997c98fd9e782b73f72c9bfc4915ba22bddcdce344c780c1dcc0faef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4e973271ee913c460255c41eae91ae40de76664ea28f97f61c6d32e8fc593f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b086195639d665f2a3c9d70ab57d22db44df2037ba94e4ec6e1c6ce7978618"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
