class Usbtree < Formula
  desc "Live USB device tree in your terminal"
  homepage "https://gnomeria.github.io/usbtree/"
  url "https://github.com/gnomeria/usbtree/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "a315eeeb559911fffb1c2a17b6ebd418143168c888db5d3b737b05d8c34b3486"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "controller", shell_output("#{bin}/usbtree --pci")
  end
end
