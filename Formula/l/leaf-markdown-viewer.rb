class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.26.1.tar.gz"
  sha256 "fcff13393d749efe738688d1a31064081957e5e8712a1a883d897d3c29959c63"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6aa4618a2f374b468024d6d215963e4dc6133a61afe1af60a03f2c1807d4b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf1947f6ac391d0b3a5914b4994ef078d55634cb6244d95de4fae0102bb943f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15dab1fdde6dcd826baddb8ae5a69b6f56218fcd829467796091186129d14c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "d54906d49ea570df1121ac10d292f9e83f0ef9a539e6529d65e35ee041e54aaf"
    sha256 cellar: :any,                 arm64_linux:   "d0e29f1637f230a21b97bc543c50d64b26f4f11245535b3b534d41af6a0c2247"
    sha256 cellar: :any,                 x86_64_linux:  "184045637a06cec1c3d1526a90505456b3f9028af3becc1bb81e411fda7b07f2"
  end

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
