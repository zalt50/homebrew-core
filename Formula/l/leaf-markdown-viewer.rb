class LeafMarkdownViewer < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.28.2.tar.gz"
  sha256 "838826fe69d90888b9a1e4d62e98565f2ab784054b13e64adba313d21a3df86b"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad3b53707c3462171d2849c00ce1e40e06d5ca4a18a8e5bf1010869ac17444e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7087ad3d54d73ee9cf44b9dfcdbd2cf1a074e85638f12a93e12cf17adcf3810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06f582dd5d155ac7a5fa51a477b9a9ebc8e188d9a17f8a1c0223eb0f527d7b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "dc4663eded85bd5d4b194ec424c543ba69914cf75707b61d15d33db9f48f7260"
    sha256 cellar: :any,                 arm64_linux:       "d3e98df50bfababd04426d35f6f2608590106748e3ddb3c6ff9e23b979a5f921"
    sha256 cellar: :any,                 x86_64_linux:      "d816aa5ab0048b842500d386abb6eca94d77a361477c0ab19400ac80201bc513"
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
