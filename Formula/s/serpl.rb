class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.7.tar.gz"
  sha256 "337669da7b4513f6772c56bce777cf0b710a1190781af75754a608c12d5142a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1db4902605e63c95c0a63de49d514a5f3d29c249b1e6f7303c705fa868f7dc09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ca2e6e5ff171384e902eea85b6b6d9dfafef71ba4f1680b2caac43cf4fe57ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5929f141ddbbd509d9cb6bf03617869f3a327e42af17b6aae04434c73d2296e9"
    sha256 cellar: :any,                 arm64_linux:       "0fd725200774bd85c9c48c9761a1e0aebca4665a2843d65f6090ab63fb96405d"
    sha256 cellar: :any,                 x86_64_linux:      "d66069dc3ea44fb915013737776d171e691eaf1899e377b517be421d8d2cee29"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end
