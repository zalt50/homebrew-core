class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "49c34032e834e319036cae8b756bb1b87e97acce626de1553d19473a79cb4165"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "497c858fe45ada94c7ba412ad882931c99eeefc8ddd2559d7fcb5ee050eba31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02d604553df5406591e1aaab317815a1b522b2c4edb7f03c158f1b87eb87dcf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3b31c53fe291d4791bb3366c5d6b4f0b492b05c8057b771823618e16310637"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ccfcb69b50e1ec8ecb1406e74d859540ca2a8652ed0083aff5c39a7affbceb5"
    sha256 cellar: :any,                 arm64_linux:   "0b07914cbd5cebab5ee0ada93735d8045a68ff3d46e2f05a902670ad322728d3"
    sha256 cellar: :any,                 x86_64_linux:  "6d32c0ec48e0391139887986138ee2963f22921c018c452812adb557fe48b156"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
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
