class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "https://genext2fs.sourceforge.net/"
  url "https://github.com/bestouff/genext2fs/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b8aba9af48e664fa60134af696a57b3bb4ebd2b2878533d7611734e90b883ecc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "025fef39421f0444a09c59feb6804620084c9cf9352afd6f4a5ce4491b475508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e89dd20410777ea21eb5e72c12b1609e203bf6a50488aacb9d7b7ca7a15d4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12c11cc16a568a0b87b394346b1c952f4b0ff36df26fa569074ebb5139dd6b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a149a2e453a8bc00516ad42fd643c0265ab5500a4b8409d80ff8d27f427ab1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d1a9a3f0ed7149c2e170d24085161d79b49baa4a7f8ec5a66b3003edc827d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "717bc3ad0ae368bd2d275a3a1d833ef78f04209cdb580c7b262e0e338896eb12"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    rootpath = testpath/"img"
    (rootpath/"foo.txt").write "hello world"
    system bin/"genext2fs", "--root", rootpath,
                               "--block-size", "4096",
                               "--size-in-blocks", "100",
                               "#{testpath}/test.img"
  end
end
