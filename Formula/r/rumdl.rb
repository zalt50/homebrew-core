class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4d8c8437d5370e9b732e319d2b7b8364fea36377104490c306c65e9630950f0c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c89a5b7a9dba34f4e6ee90703e116b8388a41d989f77041c007b1423e5a5b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729030e4ad0c09ecd31fb95a0a8e0404e97278b2cc1431b9808f7ff0741d7073"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c041ef856e3238d53c6d26f763d510ea8905eaf2b3f95ec878df4aee69d6cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eba51689d409217b95cf3ee6a79830469d9866a4986842bd28cc9c32bca3035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4adf67b49701447870278ab460a0b8b90f6511ccb6b961bf5addaf46bac8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d88dfbe04aa8c48a3398691bd0f88547cf67dc818bc51977ce870afc8890a3"
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
