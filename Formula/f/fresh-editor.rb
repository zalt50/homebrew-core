class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "1f9191a3b098e6d90a481fb8850edd1747d5ee1b5fb6961921f0c3769a44c610"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd20e5f8c08f3d60ff0961be0d629e46c027ce9442045fb2e97ebb255ca16565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4aff17007b7cabe044d5284f8fa4b8565920e6cdad758e4d8e7478f607fea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1483733989639fc5810337140bc0eac1e6434609dca5ebce723b0edbe723eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "54f20dfa7d08854b87c1c3c838d494fad1229efdd161cf50f6b868d9220915e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4345f959e14b784f68f376deb25e0adaafe8679e4ac25e92c57ab4a1e651368e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede89c7c0ce351d860c418fa474cd0a80b1052a4d60e5dbbb4bf3205e511735c"
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
