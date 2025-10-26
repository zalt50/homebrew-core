class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.34.0.crate"
  sha256 "609c9fd2a73a4c94fd05b458e83e7441de67cea9efe96adeb2e76527b16f4450"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59a6d8049af4735d74584eee9e70731118e9cb5a4b6e21cb4f6d305ae47a2372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003dc0b9b59e98fd578841f46bc751781472b449d3dca6b4480af6f42957a949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34ec4b0394c6dde60d8771a2ea3f12e5603afcef5b8a2a240a49d8c634b85a76"
    sha256 cellar: :any_skip_relocation, sonoma:        "129588c986ebce47ad0ab7c50126e017ebc76809ac040ca6126d871449249f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b483b0feb44705857e09d783065cf60d61e2a851dae8a395c2829d675b78906f"
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
