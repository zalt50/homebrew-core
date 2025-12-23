class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.52.2.crate"
  sha256 "10ed08e7e36d28460739dc907b0daac96b89b21a23c79e43e562c91618958bc1"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c832abee3b686d499aa05d2bc5fe3015fdcc06ca7152243e6f015444ef827603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6723ef59ec48f0718eb6af16f0badcc4c6b04b3ebfe2eb4e4acd773f5b102082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68758c986f0b0ae1329707654a004524219b60f1a5ca72235eeb8667b4c8a849"
    sha256 cellar: :any_skip_relocation, sonoma:        "3632d47250a54aceee117545c8c83a9c6b961a2d5253dbc84a955a3bc3790e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ab6191f73714eeadf6aad1c14757efbc853a6456a3d704de408cf6b0ec3fa67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a847603e6af8e4d51cff2dfb53c95ee32b2df99aeeaabe63285c48e38a574c"
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
