class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1b.tar.gz"
  version "1b"
  sha256 "de10cfee3bff8c1dd2b92358531d3c0001db36a99e1098ed0c9d205d110e903d"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e595a98b888d411d44c3635a183be92e4e91af8677ed3dde41f03f26d3dd5a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc26532c211ba362ba60a43eddd3162eef9554d1de33b4b8dc161d9581df88ac"
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
