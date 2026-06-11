class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "554ac23ffba4677ef1a28ca556fd3067f018ee71eba703c58fc904a1dc4fd9ed"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f4de66d903b6b0f511b0ec9b7465d27914e3fb0c2adbda8264bbdf6b6fff1c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362975936d3c22814df377e7a68ace5c1d29a37f174dd6ec51833347a87e215f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fc7d63b49a1e89d8e0066a425322c538c2527e8b560a0a77f42d7ea01568015"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b873cb6ef41506e80ca584ab72775abb67c18e8c7b7b348ec1b2b5ba3fcb095"
    sha256 cellar: :any,                 arm64_linux:   "0f683b6c15e41627abb95417891d9344965f614618c61f7b6e2ff12e7f4ec9de"
    sha256 cellar: :any,                 x86_64_linux:  "cbc6cfa9c725823bca034f60befc7d727077b27d603c275bcc79e2794bb96db4"
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
