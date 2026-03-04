class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "8d658526603f2b009564a5cfe383fb65152992655a0e25f4e62d62fdade49c5d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf56432c7f13481d70b6e481f39dec440251ef31c03a26edc640cb2d12712e2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a86239450e2eb866bc90dc8fc75053e493474770d883cf9744a6121433c51fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8864c8c94e1e6637897c2a0fba1f9c1b2f9dd3a369553c373df27826c5f140f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a8bd4f6f4a1c0045ef8ef4f5ade99a22d6c2e6e531da2335cada8df5e7dbe87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b1d234e458a55b0d09e726e7f2abf55ec0f55c2cbedbb4a76fc7e12386d96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4e053e118f81739144a64e5623e4ab883739fe2e215518976dbe9141f260ff8"
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
