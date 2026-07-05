class Kotofetch < Formula
  desc "Small, configurable CLI that displays Japanese quotes in the terminal"
  homepage "https://github.com/hxpe-dev/kotofetch"
  url "https://github.com/hxpe-dev/kotofetch/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "0e04bedde86fcdd05b41e15211aa8459d24d347b3e45cf030383f5b650c01bf4"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kotofetch", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kotofetch --version")

    output = shell_output("#{bin}/kotofetch --index 0 --translation english")
    assert_match "Fall down seven times, stand up eight.", output
  end
end
