class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.48.3.crate"
  sha256 "503981e51822433c9ca1146161168d3b09c1009066e6314cf5011ca6df2843e7"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e275b2051e55843b5016937e38c6f0783f83cc6df54e2d188aec209a3c0b32f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ee7ea6a3a4adc1dc8617793273802dd283bb21888eda1a41ef33aa94938a38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77891f16aff0f80115091d3b729addc2892b46ea7271c9367760bdab15fb608a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52c781227fbe21383d148394cfe011fd6578eb1cdbf3df3b283795defca56ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5850d11c44471833e984a4124dfe6fea01400404e9081837bf0f5891f5722b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33d5307f512782d56655e9a6bb717842aedc80f6a498829939045eedb184ef07"
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
