class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.38.1.crate"
  sha256 "59186348816cb208d07252dcb583c2117b821b96a86c0975bc330a46b8f2e994"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b5ea9783a2c9bd20e3cecc4a754bbb73cf880964fc262b7e0c8c519980b111b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2d5d3e8e115d4e843e0da7de1ce7c41af1f1afc8efd138915a7fe5fb5e2307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c85bbd759c878d781135856a4dc3fefe204f86f519684904d97b4262a7028c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bccde98525f88daa4d44bb995ec45d63feff3fa4faaba4b52d6e79cf4f2e6796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096c4183cf7655e99982183253e13901c54a8c7779148e0f2f886d3f96ddb06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f281b3f99446d2249c3b40c985156a1f158d4d8418f8d1bb78daf30b585f6e"
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
