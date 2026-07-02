class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_4.0.1.zip"
  sha256 "039cf7665c6524c73da0695eb21afee73d3c6ea5ca7eb4edb54853c19300c209"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "669559e1d86462bed585007f094af5ab2d1c11ffc8bd30e020b7cdc14a77fc78"
  end

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    ENV.append "CXX", "-std=c++17"
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end
