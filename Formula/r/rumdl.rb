class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "15e92e341a3c5dbffb402b5bcfb8f38afeeb5d45e9109c99c0628cee5d89723c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75f02fcd804f6a268a12f0ef5b1fccbf9ae50287ac083371e5686f20c2a613eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df07ad86b17fb7a11ba107c60f117740d4daa154d9883f5bfd6713e8fd2d867c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b5b5e108b765708a9c2611d5770a8b94bbdfd4482332231ad2bb2ec1066577"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f9318a0739f20537bcd7ed147f536b30cfd7b86211fe1feefd48b1eb83bb3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ea98f7ed911830e6abb13b536d199b1fd6a319d683edfd1321a005aa74d1492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600dd77a98108fda45a5b389f5084ac5b58147c82070c913bbf167ed2d081d90"
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
