class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://github.com/Softmotions/iowow"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "6a5205f36f502e03528e545c98df4f6996276418670ed0ff175cd71566ffea88"
  license "MIT"
  head "https://github.com/Softmotions/iowow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e8ff924340f81bb5b5ae2d4ab02724f487c54e2ff7ed7d59db59b3d0c8a0bd3"
    sha256 cellar: :any, arm64_sequoia: "c5ed7b1149f97ecec546c8489547ab678a39064239ef97e7c8d6fe87da6f8779"
    sha256 cellar: :any, arm64_sonoma:  "ab9aeefdc78b36f223b20f3fbc00e80fad6639bc72ecf1e1daa67540645bbb4e"
    sha256 cellar: :any, sonoma:        "310b8b583148c0275988620c0e1bf0d8c7e4bc2592aa9d43aa9b37ab2792892d"
    sha256 cellar: :any, arm64_linux:   "134b02d18ed37d7e8656b70b5d60088fe2ad67b616705a9bd7bead73a1db76e1"
    sha256 cellar: :any, x86_64_linux:  "6676e2a4d9701567ad35ee7e29f6cf918b19a316ac7472cffc235626a63e4c19"
  end

  depends_on "pkgconf" => :build

  def install
    ENV["BUILD_TYPE"] = "Release"
    system "./build.sh", "--prefix=#{prefix}", "--libdir=lib", "--includedir=include",
                         "--pkgconfdir=lib/pkgconfig", "--jobs=#{ENV.make_jobs}",
                         "-DIOWOW_BUILD_SHARED_LIBS=1", "--install"

    # Upstream also installs a copy of the source tree.
    rm_r pkgshare
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <iowow/iwkv.h>
      #include <stdio.h>

      int main(void) {
        IWKV_OPTS opts = { .path = "test.db", .oflags = IWKV_TRUNC };
        IWKV iwkv;
        IWDB db;
        if (iwkv_open(&opts, &iwkv) || iwkv_db(iwkv, 1, 0, &db)) return 1;

        IWKV_val key = { .data = "foo", .size = 3 };
        IWKV_val val = { .data = "bar", .size = 3 };
        if (iwkv_put(db, &key, &val, 0)) return 1;

        val.data = 0;
        val.size = 0;
        if (iwkv_get(db, &key, &val)) return 1;
        printf("%.*s => %.*s\n", (int) key.size, (char *) key.data,
               (int) val.size, (char *) val.data);

        iwkv_val_dispose(&val);
        iwkv_close(&iwkv);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-liowow", "-o", "test"
    assert_equal "foo => bar\n", shell_output("./test")
  end
end
