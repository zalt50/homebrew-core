class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.57.tar.gz"
  sha256 "d235374edfdfbb54567b2b5cbb26e597d7b6c5b3d3a246e111de893a740d7120"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f56f107edf2cb4ef6dd3894bd3a25e85190fa752ca61040e09ceed3791c28b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de748ed418ccf0582a937f0c01f463106088089439424cd679bf713e4ca31628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c22b4ed5ef9f6016fb6033838c51bfeb756e2dd53d1785a363a63a0d94cdbac"
    sha256 cellar: :any_skip_relocation, sonoma:        "797171185f07c5fbaf67f37860cf601e22ed569084eb3cb9943ae4924e29a3e1"
    sha256 cellar: :any,                 arm64_linux:   "7319341254f9c2ea25bf8068af2990dfa1085f4099739d94fdf09932588cc9e8"
    sha256 cellar: :any,                 x86_64_linux:  "c55fa603ab66e8f1d8b76278c16e798cb583499d543c67c2f3694b8ec201a965"
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
