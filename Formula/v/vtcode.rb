class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.48.3.crate"
  sha256 "503981e51822433c9ca1146161168d3b09c1009066e6314cf5011ca6df2843e7"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0629c4a8d7cef2568bf795a7ce9fff608e4ad81928d894f27b05a3fca28855e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8214d55f5991b2a21c287d5dd1559da66e237f234ba3e5015070746c53524175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ada9d9ad0246e1d6f1362adf82ddd8d077b0cdf2d46f745d12969cb794a2afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed4821e0e5adf3d4eac9e0a61ebef0d6869bacddbbff4e70d6e8c6a94ecb1ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473f2b6e3499bfbf1022660102ac094ffddc1eff951724d88fd6fb7cefa31442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a0abff737fc83f71849f172ac23000d8f41d44b1e1c4d73a9e6273883f76c2"
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
