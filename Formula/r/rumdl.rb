class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.193.tar.gz"
  sha256 "a56e37e3d2b7f30be5b146a9c8a2a31e6de3b2043f6668f95f93675893de8c2b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96255f7594ba0ffe5d5c28852f06032bac1756c7da1a868134833ef86f115a81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ddab8686219df6acc1c2eb22ad46420713debc6df812045860526a861931b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afd22dca2b8544981d339a677cf656df2747a37f4eaad060c746fae60053b163"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a18dc61ace3ddcb64dd5fa4373553300460eaba156654ecd9cc78e4d519c98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f16e2bac3a97e1deeb6db636de9286b0735ad0ba7a2e427bcf8954047e723a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3479fc074c1ca4841d391ba3600c320696a4d3bbbda57249de68993842e8ae8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
