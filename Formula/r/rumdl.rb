class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.210.tar.gz"
  sha256 "d0fcee891b3a19fcaa4edfd64c4d5c204e9b85a36102981008f335649d1942f9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a2091a5c442af9364c542a73f37ca562dbecec2526a66da9986f1835e3f8b01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd46331b0aa83591cfc4361936aceda495f053e62d057797ad1965717b2c7446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a79c34f02200a33842374906a8c4e74de5c4a97a377908e0861e80083ddeb81"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa36ea303c63acb8cc11b6cd7ce5114dd8147ca1fafacff33b184113bad86c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f9f51576ac1c6511fa00203d021f5bf1465aa96e5fa9fa37163c9d528d94cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52652f9f8df780d3af7fea1afbf5148fd36dc88e538c4e5f8ad42d962383497"
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
