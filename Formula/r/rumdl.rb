class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.34.tar.gz"
  sha256 "892ac4aacf39aac0b4d94612187b8b056c39af11aa576e915a6e870a17d8ec87"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8c94b2edf521aeb17a4d6298c77e366691ced483b748a83a85b15eb8fdea0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b685064125554daa8d94570f8f3dddf5429c54e02d3e620c4b1fe45c76783ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd0690c1ad60897b5af2cadb21be85bf0264645a2b0ff75684d2e7a7d542f8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6868332220f7f4300decf2741418e90328a77870f568bbc59bf494e5d48e23a3"
    sha256 cellar: :any,                 arm64_linux:   "6ec8a3a67e65aae4eb98695f8b9bb35c6a8b98ba91f570c288ec81d76b96e2ff"
    sha256 cellar: :any,                 x86_64_linux:  "61030346a87caa835e9ffea7de4bf7ef5a7de04adeeb398e21cd8dc6a8cb176a"
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
