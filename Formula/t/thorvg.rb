class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v0.15.16.tar.gz"
  sha256 "a7fc0aaf9e1aa5c1bc8f4f2035571ce87136a3c65fd9b3019eb25f9c58fba83c"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -Dengines=sw
      -Dloaders=all
      -Dsavers=all
      -Dbindings=capi
      -Dthreads=true
      -Dlog=false
      -Dexamples=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkgconf --modversion thorvg")

    (testpath/"test.cpp").write <<~CPP
      #include <thorvg.h>

      using namespace tvg;

      int main()
      {
          Result result = Initializer::init(CanvasEngine::Sw, 1);

          if (result != Result::Success)
          {
              return 1;
          }

          Initializer::term(CanvasEngine::Sw);
          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}", "-L#{lib}", "-lthorvg"
    system "./test"
  end
end
