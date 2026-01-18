class Libks < Formula
  desc "Foundational support for signalwire C products"
  homepage "https://github.com/signalwire/libks"
  url "https://github.com/signalwire/libks/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "5f91d4c5021e472eedfbfa74c33c64e568f5ac0c43958d60f7b721fdb05b7138"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/ks_hash.c
    "HPND",         # src/ks_pool.c
    :public_domain, # src/ks_utf8.c, src/ks_printf.c
  ]
  head "https://github.com/signalwire/libks.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = ["-DWITH_PACKAGING=OFF"]
    args << "-DUUID_ABS_LIB_PATH=#{MacOS.sdk_for_formula(self).path}/usr/lib/libSystem.tbd" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Part of https://github.com/signalwire/libks/blob/master/tests/testrealloc.c
    (testpath/"test.c").write <<~C
      #include <libks/ks.h>
      #include <assert.h>

      int main(void) {
        ks_pool_t *pool;
        uint32_t *buf = NULL;
        ks_init();
        ks_pool_open(&pool);
        buf = (uint32_t *)ks_pool_alloc(pool, sizeof(uint32_t) * 1);
        assert(buf != NULL);
        ks_pool_free(&buf);
        ks_pool_close(&pool);
        ks_shutdown();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/libks2", "-L#{lib}", "-lks2"
    system "./test"
  end
end
