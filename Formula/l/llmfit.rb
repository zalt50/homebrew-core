class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.5.crate"
  sha256 "c64aeaf2219c88fe16e2c4b19e4550d47e5a7535ea133ecc666c03a939ad25f9"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c0c7e08791d71b0038463bae62624ce4e59b8f8d08c710de601ef8bd51354ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86bea9f3565bfb7cf5266318a7e15b0b8952e141900cbe32130db5fae465adc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49ac1e68a00fbdbff6c4237a78eaad6ba8a18b5adc246d904370057ae2443e30"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a6d17cbd2475bd2bf0ba58cd6988433940d1e01671919a785c92a3ce58d44f0"
    sha256 cellar: :any,                 arm64_linux:   "9f47ab912ea19a7bfa342b6cf5956a250d11f7c8c578113d1fff99cc21f8c03a"
    sha256 cellar: :any,                 x86_64_linux:  "e3803680b97d733780cbd1b7e5fd0adc6b4f4468871a93230b7bbe93e4d5b2de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
