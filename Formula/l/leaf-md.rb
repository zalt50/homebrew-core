class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.22.3.tar.gz"
  sha256 "261ed18b61c0bf725204e4bcfac431431b6c6b1dd8d9845e790499ee2c3609d5"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
