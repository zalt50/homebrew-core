class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.220.tar.gz"
  sha256 "1add57fe8a8f260fbecd971ce687a7f5d0e9b3600b39a8d7bf595f0176c6ffb0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3649092a7f18b737dd4b0217c18eb465b17bb9645f2622b343d5c81b44c30893"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e749ea4ab648f400649a686ec8143fe5f819411cd0931e845e8d5c813a3e6f68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04315558515b23785856f3c2e8d72903dab680deec3bd18475f2dd94ae317912"
    sha256 cellar: :any_skip_relocation, sonoma:        "08cb0a41b954a82f20c903a5870df7c98d7fe252ec5fcff7fc744e2c94f892d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0ebc6bf6712e38e23f1dd872130a193f2f6d35a6cadb10ed1077916aed7e96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5376bc2a8c06499245a6d673169853a12ef507a34458c0118217d0a2329eac23"
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
