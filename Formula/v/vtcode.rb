class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.17.crate"
  sha256 "5266767b128b56250a3a087751aba5cde9caabf4ca6088b95cc10beb2415cde8"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335f6be1ef7558b9cfd49ff269e4e9fb3669560e87a58f445f73d906e3aab49e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3711701d7c6e7d617f9524714718d44b2d0dbbfcc1e62ff9f547aff3d13b248"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0aee4d07d03cbb3bf25ccd5a333edfbf23b51b4e5c2780645b8157f7b37e409"
    sha256 cellar: :any_skip_relocation, sonoma:        "da59bfbb8dd5a16cd7433273dc072a860b6218dfdc22ff384eed419dd622be22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2cbb6dd610d92f60e67405c6e83149dc5d821b3b09d69b137b6fae54efb933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dbe44b7ac78b3c86c02f79888c545021d84b34a9ec3879a1653151c0a6aca8c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

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
