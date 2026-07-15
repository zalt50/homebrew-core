class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.2.tar.gz"
  sha256 "347cb3b964bbb5a7e33a28255ad55de3a75465ad606376db50856b2803e2693a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "315bd70f2198e4989fdc6c0913bef679c76344fedf97ad39f2c1e7cbab362d5d"
    sha256 cellar: :any, arm64_sequoia: "0c4addbd07bd7ef67ce5eb200be561bc939dd98cc49483e48b2940fd5790b372"
    sha256 cellar: :any, arm64_sonoma:  "4b9f7c790ad7cd4436c24632cf7160ac0216ad17a2cb48bf12ae71eeb6c03e4a"
    sha256 cellar: :any, sonoma:        "9898529d66e1ec68fce6253a46d9674141c1392e0a31ff6e62aad1b2b3e8c1b1"
    sha256 cellar: :any, arm64_linux:   "2587e84b24305d094bec03eadbc8bf1e9111c74014664d5e5e19ebd1a72cbb7e"
    sha256 cellar: :any, x86_64_linux:  "6c82de9044770af5161e00797bd04601a9c05d1eb564efa8c0ffac5af137920f"
  end

  depends_on "cmake" => :build

  def install
    # The library contains multiple implementations, from which the most optimal is
    # selected at runtime, see https://github.com/aegis-aead/libaegis/blob/main/src/common/cpu.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <aegis.h>

      int main() {
        int result = aegis_init();
        if (result != 0) {
          printf("aegis_init failed with result %d\n", result);
          return 1;
        } else {
          printf("aegis_init succeeded\n");
          return 0;
        }
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laegis", "-o", "test"
    system "./test"
  end
end
