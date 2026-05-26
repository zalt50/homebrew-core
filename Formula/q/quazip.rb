class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "61c73926d4e98bf4c38becc15ba10437ab2af9e746a3982b86f7d720bd5823b4"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "411fb083fb7b751dfbe6fc4bb99cf1602e1625340cdb444f22099e406253b74a"
    sha256 cellar: :any,                 arm64_sequoia: "2ec34cc23169507cb23f4a5750228b5a3f556e1e2f869dbfb3ab29b40dc3ad0d"
    sha256 cellar: :any,                 arm64_sonoma:  "d4bd7cb4a5a1403dbf30859bdb35dd1e445e6a2e83497097789dab5e4fc14e7e"
    sha256 cellar: :any,                 sonoma:        "26a446cc2cc8cb39f200e126c20f4087e02cfb7e8c35e18a933507395694ab58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25555530fbe50636f82c9b248c50ce4c582a602cfb76bd5c3f5f991d0fab39e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afa1b2854a6e96b3bcdf24cc1603511c480e9a7e428029889d0affecc490926"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt5compat"
  depends_on "qtbase"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qtbase"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE        = app
      CONFIG         += console
      CONFIG         -= app_bundle
      TARGET          = test
      SOURCES        += test.cpp
      INCLUDEPATH    += #{include} #{Formula["zlib-ng-compat"].include}
      LIBPATH        += #{lib}
      LIBS           += -lquazip#{version.major}-qt#{Formula["qt"].version.major}
      QMAKE_RPATHDIR += #{lib}
    EOS

    (testpath/"test.cpp").write <<~CPP
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    CPP

    system Formula["qtbase"].bin/"qmake", "test.pro"
    system "make"
    assert_path_exists testpath/"test", "test output file does not exist!"
    system "./test"
  end
end
