class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://qpdf.sourceforge.io/"
  url "https://github.com/qpdf/qpdf/releases/download/v12.4.0/qpdf-12.4.0.tar.gz"
  sha256 "2783a032f443cc886dad41aa6d5fae3dabf23dec00ee7ec2cfb27ef67ebcf529"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e1c5478e15efb7eccf35f0e1464ea0384d4afcd8c6d8347de2dd1ef3cdbd48da"
    sha256 cellar: :any,                 arm64_sequoia: "ef43a7ee011cdc0f8401a11392270f07c6c1de49dfbcdc516c53a218fd576402"
    sha256 cellar: :any,                 arm64_sonoma:  "18e956371a6fdc8607834ef6cb7424aac6e925ab72b5621a5517bb1926b66019"
    sha256 cellar: :any,                 sonoma:        "ae97ea43f6d048aeb39bb4ef894305a6c5181bfc1436e415073add0c0ac93b3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017679e381a1b0179fead06203c3fceb0123d239c5443840a2e62e6327d3f38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257890275f350e66b25c6cdd5769713d038c41890d4710c644cffc1eb5cc6d66"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"qpdf", "--version"
  end
end
