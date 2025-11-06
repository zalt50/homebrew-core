class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "925982c9798acfd51f94202c8ca3e770cbd1ccd9179844bf4d30a2b2b8733b15"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
