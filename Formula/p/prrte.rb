class Prrte < Formula
  desc "PMIx Reference RunTime Environment"
  homepage "https://pmix.org/"
  license "BSD-3-Clause-Open-MPI"

  stable do
    url "https://github.com/openpmix/prrte/releases/download/v4.1.0/prrte-4.1.0.tar.bz2"
    sha256 "285ad62b670075708b9fcfe14c54baa599733bc274d10502a82e8eebba0b7c70"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "0f71161c5123695aa84865e17062bb6b9b86d53e4995b315bc4bd8b221d0dc27"
    sha256 arm64_sequoia: "6a59e04555bb0c6a290cae7cbe9c16492a800daebe02514eed7b104f32ab0267"
    sha256 arm64_sonoma:  "daae27ddb909f19f41fcb0bc555f24fea1a3b809847cc54951d6b3308315df1e"
    sha256 sonoma:        "93480f0e4ab72b3d3079cbb0adb1ecd78c73fdbb62800a7cdedc7eb9319177bd"
    sha256 arm64_linux:   "f47049dbf771197b833d0461f16dd33f4b61dc05f8c0cc976d73e3dfaaef3dc1"
    sha256 x86_64_linux:  "12e343ddb549456626718523d6680a72ee23b46b6979d55d10d0ce057ca432bb"
  end

  head do
    url "https://github.com/openpmix/prrte.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build
    uses_from_macos "python" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"
  depends_on "pmix"

  uses_from_macos "perl" => :build

  # These used to be bundled with open-mpi
  link_overwrite "bin/pcc", "bin/prte*", "bin/prun", "include/prte*", "lib/libprrte.*"
  link_overwrite "share/man/man1/prte*.1", "share/man/man1/prun.1",
                 "share/man/man5/prte.5", "share/doc/prrte/", "share/prte/"

  def install
    # Avoid references to the Homebrew shims directory
    inreplace "src/tools/prte_info/prte_info.c", "PRTE_CC_ABSOLUTE", "\"#{ENV.cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{formula_opt_prefix("hwloc")}
      --with-libevent=#{formula_opt_prefix("libevent")}
      --with-pmix=#{formula_opt_prefix("pmix")}
      --with-sge
      --without-legacy-tools
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Based on https://github.com/openpmix/prrte/blob/master/test/attachtest/app.c
    (testpath/"test.c").write <<~'C'
      #include <pmix.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main(int argc, char **argv)
      {
        int pause = 0;
        if (argc > 1) {
            pause = atoi(argv[1]);
        }

        pmix_proc_t proc;
        pmix_status_t rc = PMIX_ERROR;

        rc = PMIx_Init(&proc, NULL, 0);
        if (rc != PMIX_SUCCESS) {
          fprintf(stderr, "PMIx_Init failed: %s\n", PMIx_Error_string(rc));
          return EXIT_FAILURE;
        }

        printf("Hello\n");

        sleep(pause);

        printf("Bye\n");

        rc = PMIx_Finalize(NULL, 0);
        if (rc != PMIX_SUCCESS) {
          fprintf(stderr, "PMIx_Finalize failed: %s\n", PMIx_Error_string(rc));
          return EXIT_FAILURE;
        }
        return EXIT_SUCCESS;
      }
    C

    system bin/"pcc", "test.c", "-o", "test"
    assert_equal "Hello\nHello\nBye\nBye\n", shell_output("#{bin}/prterun -n 2 ./test 1")

    assert_match version.to_s, shell_output("#{bin}/prte-info")
  end
end
