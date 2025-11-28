class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.184.tar.gz"
  sha256 "b6e6a6ee59ebbd166a1e9455bcafd64a1aaa7d8587d154d733fc458eefc643bd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b9cbf096e06d3ab101b063c0aebf8856651648caf17c2c85876b289e7bbb5cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0e14d5b62b9f1bc73de05403a8f9b1a62bc8db110997d8fa73bcc41996a270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7527f418b6e5ea8feca0eab18e959ca2d3b0132843be6660a939cade7c57acb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b9cfcc08087e2924ba4416f2742becb1ad120b75aff7f31f5b57c3024c5a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd97ea7b2a5904652c52722759eed8bc0bced25b9376ed90130b1f85bb7cd60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd8e0fdc7b3e6bcc5c9d5cc480679d2a1ca6c6fdfb1858fa2482ab7a44cc3077"
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
