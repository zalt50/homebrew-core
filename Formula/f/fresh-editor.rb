class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.63.tar.gz"
  sha256 "03591226cec7119b4710182ef6ce7e2575137d57e1880f042f73277d3edbdcd8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e525347403ea1459ae965d523d1b4247366610b8649d2be12b9a3a7510ea767f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebf8ea6ed7e54de6cf52a0bbc1cb1103800048be3be1e9069bdf0f718721381a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4628df3011c4a54f7c0304d7e3249fec4f348bfbbdd90038f5847c38069c8c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce50460e49f1b622c99a81617ccb18968b1b31492e84f6aa8653c89a12e2486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa1190002f1d11d189a3751e56af7824f950342180fb59efe161903eded2025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb18e2f257708fdc1d9c9b462fa175745d53fee83f05e6bf3ba53982e7a5480"
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

    pipe_output("#{bin}/fresh --no-session test.txt --log-file fresh.log", commands)
    log_output = (testpath/"fresh.log").read.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "INFO fresh: Editor starting", log_output
  end
end
