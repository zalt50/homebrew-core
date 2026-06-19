class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://github.com/lh3/minibwa/archive/refs/tags/v0.2.tar.gz"
  sha256 "aacb2dabe78874923b1eea6197919c0f75e12de87bdf906fa4adf58a6ab1b25a"
  license all_of: ["MIT", "Apache-2.0"]

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "gpl=0"

    bin.install "minibwa"
    man1.install "minibwa.1"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath

    system bin/"minibwa", "index", "chrM-human.fa.gz", "chrM-human"
    assert_path_exists testpath/"chrM-human.l2b"
    assert_path_exists testpath/"chrM-human.mbw"

    output = shell_output("#{bin}/minibwa map chrM-human chrM-read_1.fa.gz chrM-read_2.fa.gz 2>/dev/null")
    assert_match "@SQ\tSN:chrM", output
  end
end
