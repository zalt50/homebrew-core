class SlintCpp < Formula
  desc "C++ library and headers for the Slint UI toolkit"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1cce5cc1e32a140e35366fe819fcf17a7b278338f67073d7bc97d4fa7a2a4d4e"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    # Optimizations recommended by upstream:
    # https://github.com/slint-ui/slint/blob/master/.github/workflows/cpp_package.yaml
    ENV["CARGO_INCREMENTAL"] = "false"
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "fat"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

    extra_cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSLINT_FEATURE_COMPILER=OFF
      -DSLINT_FEATURE_RENDERER_SKIA=ON
      -DSLINT_FEATURE_RENDERER_SKIA_OPENGL=ON
    ]

    extra_cmake_args << "-DSLINT_FEATURE_RENDERER_SKIA_VULKAN=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *extra_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <slint.h>
      int main() {
          return 0;
      }
    CPP

    system ENV.cc, "test.cpp", "-std=c++20", "-I#{include}/slint", "-L#{lib}", "-lslint_cpp", "-o", "test"
    system "./test"
  end
end
