class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.12.crate"
  sha256 "64290a97f3c2e712a5ababf9ecbe0d615b698518c4389fbe0545401f7071daa9"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a154a3b6fd6d1d8dae7f6cf850eefeab6a1bb60253c8948d333d6234ad985b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd47106773d1cb8acd4898cf3db511fd849c4ab032db873eb9886030f6bbf0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f01b0083b188b8b9060f52eb1d346ee6fa606c6de35ca3e18b2fe2379a78f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "857ba84850a75ecf94453515c2260f593ba70e3705a3d603af7e054320db4451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "141afcab4e0e81832f49dc691f6328a455519c1dbcc063c4bbbd41c531853804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19ab5ff7c78c6b0672d08034c31d2ffe1590f8d48ec7bcd75ddb2e50c69f3f1"
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
