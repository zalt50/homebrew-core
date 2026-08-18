class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://github.com/Softmotions/iowow"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "56148104199c567082d4dfb3addc4e304d2308101be5454728164386b8605a8d"
  license "MIT"
  head "https://github.com/Softmotions/iowow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b21a214c32770aca0640784c45fdf33489db118e3051c66d8bfa2c9958386a8e"
    sha256 cellar: :any,                 arm64_sequoia:  "037aeefb4df2c9cc2c239192b51713f918271e48455c48bdebbcf2d688bb212f"
    sha256 cellar: :any,                 arm64_sonoma:   "2fba078871f285e4275e5335150ef00f6615d5739d7a9280919edf787f9a0b5f"
    sha256 cellar: :any,                 arm64_ventura:  "653db3534479fa6987b0276850e13ae821507a3eb40131f9170e4ce1158bf56e"
    sha256 cellar: :any,                 arm64_monterey: "02ac4f8dc19959efbfd5bbac2685c2532e9de9488f3f51a218e15b2767727559"
    sha256 cellar: :any,                 sonoma:         "bfdd0df35ade257dfc24898f77d0134176f5d3c13a12338c4d0e705451bb269d"
    sha256 cellar: :any,                 ventura:        "e222abf0c1723ef6439607386f136582ef7384aa2c5df9e989386f3be4c5e5c1"
    sha256 cellar: :any,                 monterey:       "791aad132a5be42cbde1b97c8f38dc6c63f84f382aa94980b9fc5371778deb20"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4b3ddbc7bd008a380416bef79e794b4ab3e1085309c6b5f22b2fed244dceca09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c50abbc4cf8ac933da6dc4be5dab2ca27db4e653fa7eb7189f00378561c3d7e"
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
