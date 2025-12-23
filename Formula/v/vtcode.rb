class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.52.1.crate"
  sha256 "3bb88fffd2bf4512cbd4704af3de41c2486be36d5fb5884f61fb122e13c825f5"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aa4733fafcd439f134b60b35681bec93d678dd0aa2b1cd83d8c820150537288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20ad028ca52c4cd1030728f2154fe545227f6523291f8e060a7588fccf39c388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac47009775a0a35bc80ec510dd900c3d6f62694826fd4fcc74a3cf1cfe52709"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd3d77918060d591c85bc99488c917d4ad6cfe57985c23b5417d5cc5b3b8b28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef65885b1d299d825140bc91f76cdf7331ef31c75cb0d911aa7a89ed1bf06dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66063d4f30393dbc6dc3c6691dfa3b4f7a4015ee94983ea78d46cd78ca277dd6"
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
