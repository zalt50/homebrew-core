class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1c.tar.gz"
  version "1c"
  sha256 "7bc489a1a77ce718c84b751a57779ded6bb192cf54f9cd0bf7bff2527cf98bfc"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1b2c37826bee586ebbcf04b697dbd60f4056e87893597e26ac429091f99eb13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aa0cc94db21b3b5cb29a330a8aab4b0fb5612f2b3fac6476fc298d99ca26b9d0"
  end

  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
