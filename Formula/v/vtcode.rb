class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.21.crate"
  sha256 "2f4756560144277bfa012fcae8a6b02c23444f37545b2da0d3875eb430db794f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c9b5ecd091b0461b83061bd76407240b417e293994c7804ad6ad91358809c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e783f658edc105acfbe141ff8fda9ee0f8d60286516695c6cd41298acf3d99c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fad7cf36c9dd5b7720b0c00f4d70f49d8ecc60665ffe437664c00a1544f81f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "acf8c6342632118349cf220c5f913252519ca55ad85abd758eabfa87cd8bf5ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d057e8fae1159dc128dc625f2346219cc9befb394df37d6761033b850afcbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca2030c6ab8409c74545f9df714bfa0800adfbb9e9770dd04f10a819258bc8d"
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
