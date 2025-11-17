class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.177.tar.gz"
  sha256 "f9361c111628ec1e5da20b7e09bde814d671a875f5128b5dabdd0d446da3fa72"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368b69c2c562af02ba8ff53708f71a5107ab48d05b2f6c8bb9d662e2edaa6f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aebe3d65f2ffe2f719d5fac89f89e14303b44370f93e20b160621d2d3993ff63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b6ae8cd969efc4e3d397fb6d7e9460439c0f7fe5c4e3c39c0eb5e0507431e5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c634e3e1a5e65f89a1d41fb4b37c22570a61f15a0896cee70352421ff5990be7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ceecb4b020d469aea3e857861d3b25ca288af79c04a24e2a7f164de75ffd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77caa3e74ab01ab0e6b8494c089f7df54ad6f38772296aa5672d664c13aa77c7"
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
