class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "7f90fb45232b7aef3831cde0f48c28d4eedc77d67edb7642f352c4b852624a1c"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0a3e584b805c966e2dbfd88d0c14fd624d5cccc7182ada2a3abdf85ff4bd81d9"
  end

  depends_on "fzf"

  on_linux do
    depends_on "diffutils"
    depends_on "less"
    depends_on "libnotify"
    depends_on "vorbis-tools"
    depends_on "zsh"
  end

  def install
    ENV["TERM"]="xterm"
    system "./install.sh", "--noupdaterc", "--prefix", prefix, "--zcompdir", zsh_completion
  end

  test do
    # arttime is a GUI application
    assert_match version.to_s, shell_output("#{bin}/arttime --version")
  end
end
