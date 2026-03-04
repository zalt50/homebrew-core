class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "3fa4dd4412a29bcca00a401313f065ede306ef4b1ba8966b457e56bec3c521f6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af68a6ffbc544dc01f227ca5868f3db7dfea58ac0eb09dfb60ea0dcda1d6e6ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b656f80152dbcebfdf1133f5cc4c9be4c3083f2e7c4508d2f0c0817e9593a295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de68a9f7d0ca50ec71dd22c872330373969ca2edd86408b028267c073566b77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c0ad1f5b09eb9e6db4b17ae632f2e28b702aa4efef9a8e8bf866e949f7e095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77b5a6cdce463f895fdc8a779f86e643d6a3ade006df0d00f8206ef6966b978e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc5afe1bb978583f808bf4bf270ba8129d87c8851687899ec2983885bd71425"
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
