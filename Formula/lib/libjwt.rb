class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "23e7cc71e87c46655cac3f7f76588f3ff3e7b132cae9584d4e8c91fe69e34f84"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b14640a955084d19e7d4cc294106802f9946b05c67b1785d577a380c4826ee4b"
    sha256 cellar: :any, arm64_sequoia: "a5afed5a49f461fa59da6d344c5b0a940b033ef50b8fea1ddf87a43612189539"
    sha256 cellar: :any, arm64_sonoma:  "fde9965db3572f9bdec430f5ded30602ad20ecfbeb19257e1b47496a095ce042"
    sha256 cellar: :any, sonoma:        "ce2214ec0daf7622f59d1e2646b6e092d6b8c2163de23b534296747d98bfedb1"
    sha256 cellar: :any, arm64_linux:   "2e50ebc79576b29b4680ad534c718aa302c6a38683dc306945ad7b158418874f"
    sha256 cellar: :any, x86_64_linux:  "2c7b85cbca44de73a8cfc6a6286867341d6037f4a4e1c708317cbc3851e654fa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <jwt.h>

      int main(void) {
        jwt_builder_t *builder = jwt_builder_new();
        char *token = jwt_builder_generate(builder);
        free(token);
        jwt_builder_free(builder);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
