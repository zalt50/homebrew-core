class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.42.12.crate"
  sha256 "c5529ff6b97cfdfde587d3cac9a3cef8dbfd34e1f42d333ea080be250978d395"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "330da8160e786bdfa32bce541950d01f3d6c3069c5f06396ab366a5e483fd0a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "403915c090e9aa2bc41636b4a2c5da9d831a8c145d00d530672e0c416d86e779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "def2585714b1d51170a9eb52fcd808078c36249fc0d29a26d113b3b22b82c2e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b37b8ef861c6e4965fb069d0ea3637a558ec8e66b2da0e6a9cb3339cb1f8636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d6a89566b90ac575b1c3311960c87f55dfd42db0440dcf0dec9f80a0a09446b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b60ee08e40f580fae9e36be93010369680e5306f99b9e643adcdf6f8a8f6a0"
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
