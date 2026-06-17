class Tuxedo < Formula
  desc "Fast, keyboard-driven terminal UI for todo.txt"
  homepage "https://github.com/webstonehq/tuxedo"
  url "https://github.com/webstonehq/tuxedo/archive/refs/tags/v2026.6.3.tar.gz"
  sha256 "1191eb2227360451e665a5bc01584251bc107c7979cc93439c873a35ab20ee8f"
  license "MIT"
  head "https://github.com/webstonehq/tuxedo.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"todo.txt"
    system bin/"tuxedo", "add", "Hello from Homebrew"
    assert_match "Hello from Homebrew", (testpath/"todo.txt").read

    assert_match version.to_s, shell_output("#{bin}/tuxedo --version")
  end
end
