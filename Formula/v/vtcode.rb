class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.11.crate"
  sha256 "1cb3d1f31b82e76601f2abcefb85b44b83f211eb31aa8ab149046cd26b7ca4ff"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aae9f9ee2c0de7daf51d51d2f71df6f0dc6ee0c388c5a1abf95e9e592041749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8073cbb1b3e6a3e301e25abbf41e7ad8b0f8af1e606fcdca38fbd2464da1e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26875b8a4cbf786dcf0f2960bb431d4cc3857381757128180af003f857c0982d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02547ede85d7ab8d8a928f99fe87116a94706296e414ac4105aa6553ce200d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6649b78d4774e8842f5c01b16fee74a105c0a0d4c76ac53d57eedfc2029922ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19128873943becbebd1291266bc0db81237c133ed1984936c049b883a2d7736b"
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
