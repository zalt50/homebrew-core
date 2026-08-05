class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.51.tar.gz"
  sha256 "90465ab1cffe277f4110c1523aa79457e2060843233214f0a5a584bf19f7aaf3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccc0f31dd2720ccbba6e8091b33418b32826f6f45b8c859f735746cf3279c2b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3208203fbb3915340cdae734858fb3b42795a96a5aa8fb7a4a59c080070a2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75bedfc2e5cc95c27bb71796a0d6d0de83626d835dbf0f23d204db96858f67b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8cb0ce879c1c527907cfe3c69c5081f293217d736c6917863bc523d26082bd6"
    sha256 cellar: :any,                 arm64_linux:   "78b3d6379406eb0c8272749b0eedfe57eb66606f21b50c3733d33d9f3b5aee4c"
    sha256 cellar: :any,                 x86_64_linux:  "e84abda39dfb77cd98ab7020844cc104c00ce43d40194bc578e2af2641b6af6c"
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
