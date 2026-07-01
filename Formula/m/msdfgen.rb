class Msdfgen < Formula
  desc "Multi-channel signed distance field generator"
  homepage "https://github.com/Chlumsky/msdfgen"
  url "https://github.com/Chlumsky/msdfgen/archive/refs/tags/v1.13.tar.gz"
  sha256 "93cd1ad8918c1a78c5c96e82d4f4c77f0eb86c2e7e8579a0967e54196c4b7167"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "tinyxml2"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DMSDFGEN_USE_VCPKG=OFF",
           "-DMSDFGEN_USE_SKIA=OFF",
           "-DMSDFGEN_INSTALL=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"msdfgen", "msdf",
           "-defineshape", "{ -1, -1; m; -1, +1; y; +1, +1; m; +1, -1; y; # }",
           "-o", "out.png", "-size", "32", "32"
    assert_path_exists testpath/"out.png"
  end
end
