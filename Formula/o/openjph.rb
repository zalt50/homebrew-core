class Openjph < Formula
  desc "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)"
  homepage "https://github.com/aous72/OpenJPH"
  url "https://github.com/aous72/OpenJPH/archive/refs/tags/0.28.1.tar.gz"
  sha256 "89629a3c0f61d474073076bb6195e9bb1d63fafb2e1c57ab46aee53a62f21819"
  license "BSD-2-Clause"
  compatibility_version 3
  head "https://github.com/aous72/OpenJPH.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0019d9813f83036d93de23a3993a4ea6fb61ef25b3e1324692f2e523390c864f"
    sha256 cellar: :any, arm64_sequoia: "1946b7a8fe3cc005a03afefd6e49f1c314c48a5caaaf32e4d34b644a5a926836"
    sha256 cellar: :any, arm64_sonoma:  "61c24fc5dc46c7c621158153ed708d627a0ad91a0a4e98f42b2514c0671f3c32"
    sha256 cellar: :any, sonoma:        "77d31b794c8e147cddae3181054350e5475d8dda931b14982fcc5ef5cf235cdf"
    sha256 cellar: :any, arm64_linux:   "9d86ed47fbff9838f274fcdf9475f7efa4905b45d4feb2809bdb252ea1e641ff"
    sha256 cellar: :any, x86_64_linux:  "5a1ae1bcac70f2be05d3938205c403d75aa2aaa41903ebf1ed05d9894b2a60f4"
  end

  depends_on "cmake" => :build
  depends_on "libtiff"

  def install
    ENV["DYLD_LIBRARY_PATH"] = lib.to_s

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test.ppm" do
      url "https://raw.githubusercontent.com/aous72/jp2k_test_codestreams/ca2d370/openjph/references/Malamute.ppm"
      sha256 "e4e36966d68a473a7f5f5719d9e41c8061f2d817f70a7de1c78d7e510a6391ff"
    end
    resource("homebrew-test.ppm").stage testpath

    system bin/"ojph_compress", "-i", "Malamute.ppm", "-o", "homebrew.j2c"
    system bin/"ojph_expand", "-i", "homebrew.j2c", "-o", "homebrew.ppm"
    assert_path_exists testpath/"homebrew.ppm"
  end
end
