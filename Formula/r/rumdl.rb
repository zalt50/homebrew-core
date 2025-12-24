class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.0.201.tar.gz"
  sha256 "169176544deaa5f809333b24888653d5c95c7d3921e4db625895452b8e11cac3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b096af0d412cfb21e6ca348f0f487a827a2122c6955998d52c624a4c5f7bc22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad101fabdd6ea8b22a8e1256761ae93de071f5dcd56fe544ede6aa8e26eb1dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7771ed2f9c9bcf40a9aec3fe8443191f5bdd48fa8ade722cd61c43621dd1e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33272cc748965e01f4d6b392a10c70f96d9e6211f5039d906ec77a556ef8e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744f4bcdf5e0d9f644e49c3e16e2bd2c38c56fd40aa443c0f1b23a85437c3da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d77b8284d3782c5511b91c7ab8bb03d53d3796071ddaf350fb0e1629aa7ab4"
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
