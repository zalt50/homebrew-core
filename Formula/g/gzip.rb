class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip/"
  url "https://ftpmirror.gnu.org/gzip/gzip-1.15.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gzip/gzip-1.15.tar.gz"
  sha256 "545886cf57fa88a65e967fbf705903d7fcb2567c82c7342493e82e8d7b1a210b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a8178e53f351a62fbbc3e5dd365893f636b8c24cea7e34fb2544d10bb3fabf5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0806e22497cecc96b52a14fbec21c29df976b5ae40f365a55508c23c2958222f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c82c69f648546f3d0e962e9012a2cb258b454b098ae880880dc88418dc544a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "595f0a87dd1fe49c90e97911e72335a00cf096adbf84dfb17745dbf351ab9d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "d55108d43ddf0f8123694f06882e223023cf4346f9b9640d6c33b657d19260bf"
    sha256 cellar: :any_skip_relocation, sonoma:            "e590ecd558a1eec60fe790370d3ab2cde6d44fc918fe64ec98a56c31fbffc36c"
    sha256 cellar: :any_skip_relocation, ventura:           "39d86283bbdd91c6347ce5c7869e5a75db4d0bc6e961c8763fb7e81802cdeb55"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bf3ee62bd32f32b5288069e02bd54a9b1df35b2ec45dfc1a403aa95c010e0f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6cdbf878eda84da0ba1cac4bae09d3bf3c91ba1d5666806f9fa1ed19acc1f142"
  end

  # Fix compile error on aarch64 Linux
  # gzip.h:120:21: error: expected ')' before '+' token
  patch do
    url "https://raw.githubusercontent.com/OpenMandrivaAssociation/gzip/5a3c8e5316bac3ac837f7aa8dc7e3a4b0ba74321/gzip-1.15-aarch64-head-macro.patch"
    sha256 "82ef5b24041eeb86511ce67cb4e60edf8fbfcce01f7a1ab28fd1e024a3050df0"
    type :unofficial
    resolves "https://lists.gnu.org/archive/html/bug-gzip/2026-09/msg00031.html"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"gzip", "foo"
    system bin/"gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
