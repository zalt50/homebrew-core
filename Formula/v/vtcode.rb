class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.18.crate"
  sha256 "03e1689d2a7d847f32fd7ebe741a430782978ccb2b10c1ed0e7812e85cb5135c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7e91ee9160c37d75c3b008862345881339eeeaad50b8e1870b03c471f0dab53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e426f1adfd8e0f800d5cd8d0c145f946751912e9392f56ed4c0569e7e9529fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3642f426edd562432dca7d6644992ba92e29346d89409e7df90946a32c944e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d81cb216a1945ee45d045b81461cc3f63ec82d163e8bbaf4753f06c1534fe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0728e11854aaf4d7a8c47f88298b5b17240b94dcbcc629c6ee091b4c87f14e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5676394c854ee2f6a7c2e22b93e78bd4ae8e85981f6dbbd54a72dd8041efee"
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
