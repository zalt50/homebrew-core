class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "fe3532da7980f9a0b74c7d5daaed44865fb3bd65bda84e9d3c690a019b44f6d7"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "869af96a8d1fed6b6aa516a9ac93a4763997bf27b24708d6d995d9371a526d65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b402ccb4842c5e1c5607433b6e8145d76dcd280c40c9df2691ec32a081e09bf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39db0b70848ef39ef66c893138e4916a786a6ca4185a16c94d5d1160f749f2d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "646b223453e96a51a57cac18732bddb25a1842a2efb9d89137ef4a6e4d9be45b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb2597822285a93c4cea71af36b01bb9cf0e374acb69b3bce168a1edd227f187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfae323630b48bbabde25773cc9e990ebac6ea13c9c236a9a8e7f6aeadaccbd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end
