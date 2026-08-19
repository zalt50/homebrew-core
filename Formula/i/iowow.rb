class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://github.com/Softmotions/iowow"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "56148104199c567082d4dfb3addc4e304d2308101be5454728164386b8605a8d"
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

  # macOS /bin/sh prints `echo -n` literally, so SYSTEM_DARWIN is never defined.
  patch do
    url "https://github.com/Softmotions/iowow/commit/759df0c3e907f0e524affbc25c5bbfc52e75ab5c.patch?full_index=1"
    sha256 "8ce84b5d08848cad9048a52f45d2734b634a0edbb62b9753b92e1ccfa0292992"
    type :unofficial
    resolves "https://github.com/Softmotions/iowow/pull/60"
  end

  # The Darwin link rule uses an undefined variable, leaving `-o` without an argument.
  patch do
    url "https://github.com/Softmotions/iowow/commit/607a434d2c0d06d791d289ab77f133792867093a.patch?full_index=1"
    sha256 "c01f417a0768e386618478c8622398454abb76e0a885969dd5f6a3a89d6fcfc9"
    type :unofficial
    resolves "https://github.com/Softmotions/iowow/pull/60"
  end

  # Apple's strip rejects GNU `strip --strip-debug`.
  patch do
    url "https://github.com/Softmotions/iowow/commit/08ff23906a1bdb5ccf15ed4d4c0fb1f61e0059fd.patch?full_index=1"
    sha256 "e04e9f339609e07d436a89a1b0f93540325983a08242f536db745d1706950968"
    type :unofficial
    resolves "https://github.com/Softmotions/iowow/pull/60"
  end

  # The shared library is linked without LDFLAGS, so it does not record its own libm dependency.
  patch do
    url "https://github.com/Softmotions/iowow/commit/4afef71bff2bc36ff6e33440d752769d732da044.patch?full_index=1"
    sha256 "841cca4d79825e8a2b5d7e34fad545d9e98b6d85ea3f6f3fbf5f20f857b93212"
    type :unofficial
    resolves "https://github.com/Softmotions/iowow/pull/60"
  end

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
