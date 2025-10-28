class Semtag < Formula
  desc "Semantic tagging script for git"
  homepage "https://github.com/nico2sh/semtag"
  url "https://github.com/nico2sh/semtag/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "37890fc5bbdeba923b51ff615c4e99b002c95d922925ed1efefd117ad7934548"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "933179267efd127dbeca0f0b337bdb6eb1150ef3c8706759195b00a0a30bb16b"
  end

  depends_on "bash" # Needs Bash 4.x>

  def install
    bin.install "semtag"
  end

  test do
    touch "file.txt"
    system "git", "init"
    system "git", "add", "file.txt"
    system "git", "commit", "-m'test'"
    system bin/"semtag", "final"
    output = shell_output("git tag --list")
    assert_match "v0.0.1", output
  end
end
