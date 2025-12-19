class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.197.tar.gz"
  sha256 "c78f1de6dfe6ecebf4517255c55645986592b91e6c69dfd87c157db242708a37"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f9bd4d8d0f33a0c906336ff8aca7e3069eae4596fd2d744cdb9035823aa7df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b367b6be98d45acaf917484801ce9b93da369c2207bbe8388cffebc2d86114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "061d3145258c6bf391873e5ed16cb0d1fa17d2ea94bec2da35ebfe365f803830"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e350009fec92051718a7518b41293ab91e8665d5f414aeca046be7334bdf429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e88acfbf19abfba5655bcdb8dda5d825998049f503af451c52745228561d210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc17fa003a0363f298c9ea6774670d8daa2b59024b7ebeb62dd8715fa611748e"
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
