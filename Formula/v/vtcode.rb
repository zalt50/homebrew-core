class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.11.crate"
  sha256 "048e37c3f35611973b88259a1d9eb3ec122e333ede74ddf8894691a7fb96004a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "105cd112a0d16767a40953814ff0b9ec8c54345da15d3a230085b652d6b302af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0522247324aec787be5c74ba23371ededd9a7a4c946fc1c4dd5c922433c006"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c06a19e8b3522421f2159d238cc88a453cef4a46376b9c744f40a4d1a7b5174"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff2b951be70be25849c0e3bf87ed7b3fa3918294f96250379e9e98a1bcb57e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df9630a0e8697dba04a463635658ead61ca3a6f077d444267dd65948a84b323e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b17224dd1f4c22b4d32c6e50ca3da6edfa14dbd2242817247cb987d0083162e"
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
