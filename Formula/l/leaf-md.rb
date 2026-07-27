class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.26.2.tar.gz"
  sha256 "f102c5dff2e20955f8e5ca69512b1375ea0071a6ff7e4f5d26cfd9397daea27b"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff45ec453e8818295a1ed239efa4b65f94b8da18debeddbc9611c6ff12adf676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324cc1e7ac189bece04db5dde0161378bffcfe7faaf7c4cdc0134f962940b92f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3546c92a0574cbbbb3ee5117a38761198a8b82efbf60b05917fbb5213b97257"
    sha256 cellar: :any_skip_relocation, sonoma:        "69056b51068b3b7bde38a6e521506e46c735194984014f540a57deb19aa32e7e"
    sha256 cellar: :any,                 arm64_linux:   "a6721e0a2160d0100ac534b5aedf4a7e0edb7670988a787ab4d11ff76f4a1a5d"
    sha256 cellar: :any,                 x86_64_linux:  "660ea2c1f5a2b945c823a759c6cc627ea5242451e21d7b495b2b47d3a9c0e593"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
