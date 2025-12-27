class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.54.0.crate"
  sha256 "93db5dd0bef0e7b2c8df36c1ce2fdf3b1ddc939af441a3dc24714b08448e40a2"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "076b64309338fab6db6de1b120614a0682b9562b9305df549ca7eb770402edbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f974e28290e9fe4136a739368a12d6a3c7402bdeb48657f3d95fd22e0c075f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9572df7244fa3d948ec22fa1fca1354f56cbff77c9b4a4e15d3068891195ce7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c1b9a8616c39e0b0623c89bb843a6fa2669eeb85f69cd1831920061b3c6f9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18430fde5bd3fc12a61c06cb7099161075b14909d2f42f4eb960050aeffcc4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86fedda567ad106836abba6e15fa5cdb1403a96608b905c7ee354000956a95a9"
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
