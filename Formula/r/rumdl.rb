class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "ffa94130a747cac3668593e8919b836369384be32ae963650ab972c39db25b69"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b4f6c30b37c89265cde9f790b4c8394c0f78a1c8ce0ddd5fd9872b594d14006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bdbfc93db9f12bffcd48e7e6c72a648db238bf1a772c1fe76ce3775ba43c572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013b04011b050d3d6e942e839058522a24641518d44fb1c067fa38e1fc9e0357"
    sha256 cellar: :any_skip_relocation, sonoma:        "91392cd348cca9ace03cd421eb407c44848992e6212e9f5047e54e1bd5a8491f"
    sha256 cellar: :any,                 arm64_linux:   "de66ce2f8f5aa3906fe0942ec1828c8176f8e6fe9998723ed01613d1b0512029"
    sha256 cellar: :any,                 x86_64_linux:  "1cb4ef9e8ce442a4f5cad78541420e3f8848027dacf57e8d197768eecdb7155f"
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
