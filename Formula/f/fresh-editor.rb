class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "fc2d083c84b1b74d76fc69993891e70d51ff65ca562ba812d68fefb34e8e8144"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2492baa6f35328b5b897012916dcc9f0de0cc0497100f899f9a3c941d3a68ec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afd148581e3e7c52582c49102e79ad622be3776cea9185ee08dcdbe330ad82c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f8e7112f6ce08dfcc56b0c4fc4bb770f579c17b60cc79c2e1ee4ce5c5516a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c57b368892da20720cc827cf1794198a6dd84fc7a4278121e2344465145db6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40961a6af4c2fd591ae7e827cd14e98cb6c918a1b4e7eb005913b9ec1dbc2c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110a9c5d6d645cb660cc57425f701d6a5c3c2d6cdf6fa0d0733dcc1ecb6109b0"
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
