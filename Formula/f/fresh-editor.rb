class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "19b075181323af7d71f41357c0b0951938136556a37a73e1a0d43b2f21a243f5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dd47eff3521cca93fa55b53b32004559b3e1e3c3a914b776437c66dfdd489c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2376116f4d6ff96f326220078d45431bc0194b1c500aecc79307b6d7e4aa7ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aabd22655c4a38f3a8c26dcd04d17da7fb0f42fe0cd50dc693ee35895afd78d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d94650f052fcaa8aaf905b5d25a541eb95db9f27d9f435c1b76073f1727b4c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a97d0c24cabd4b343f00bfcfdcb5b5a6551793600ec4786513d6e0a0a2271d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a85189b359e3e6eeae87cb78a679a66e3b1d45224912f07b3e2e7b709119c7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    # Test script mode: type text, save, and quit
    commands = <<~JSON
      {"type":"type_text","text":"Hello from Homebrew"}
      {"type":"key","code":"s","modifiers":["ctrl"]}
      {"type":"quit"}
    JSON

    pipe_output("#{bin}/fresh --script-mode --no-session test.txt", commands)
    assert_match "Hello from Homebrew", (testpath/"test.txt").read
  end
end
