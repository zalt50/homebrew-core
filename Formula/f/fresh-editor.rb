class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "cc46fae14ac190c97d8d77ab2e2d93f0c2b0f65ad9552f838ec41cf988c2ddb8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4e05898316084247c105858a14cc4bd2baafd0e36f3b9c31d2851365cd2151"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8bddce4085b28fdbb6c2d8e974c5c68a7b45ccefd29c6be4d263968ec0afbf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da3600e4b0de11d3ece901075374476532993b8e4d276f2a1700f6ed4daa6c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f35b4ea444f7348adeddfd40fddad72aca22005aa24e5c0cedf6df95d9806b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16f3ef247c21663762e1c4392a9e2c54d6f07baa0eef3cbe384c3a3fd118e445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e475ade3994f29c21a96d5198f528a3cda3d34e919d1036037c721dac713949a"
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
