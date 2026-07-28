class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.45.tar.gz"
  sha256 "6a52a653c0972928b9506cf0ff0ca0fe510b5f86053d29863eefaff44fb293dd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5883d64ab3f9d42d527257ff80473a5d1ff39fe9ae5d254538ee393f0118a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dba87324c8a58147b8368697f02e056282eb470b4eb757c3673437e55413f39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf47431944039d81144119b1e507696b2e75646aa428f2dc67efcb5ddee4e4d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ab05c46c02026dafefe7895753af1a3215ac804389ea857725800c9a803415c"
    sha256 cellar: :any,                 arm64_linux:   "0fce6cd82d40ba162518a050285e7b11d07bb9553d50d198e905bc34085277fc"
    sha256 cellar: :any,                 x86_64_linux:  "2988e62f71d40a15b1828945ef99b1b8300d0c474f2da94bd10093cdccfb3663"
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
