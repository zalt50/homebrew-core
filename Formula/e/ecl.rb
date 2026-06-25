class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://ecl.common-lisp.dev"
  url "https://ecl.common-lisp.dev/static/files/release/ecl-26.5.5.tgz"
  sha256 "a01a5bcda8c5b73e59dda3494fd13e5fec5db6aa1dad782c3cc3bb57f1633435"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  livecheck do
    url "https://ecl.common-lisp.dev/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "0f7e05aeec7f7aafd866af99e623694c15a84a3def12477da3f619a4502766b2"
    sha256 arm64_sequoia: "1865df5c96476b9feb55a61c358e8c52d8fbf41d977eae8b9515893f5a23222f"
    sha256 arm64_sonoma:  "b816ed156a7176b2c546eba281326dd830090b62143414dc404bf78a18cf4b49"
    sha256 sonoma:        "10ad3c74b525e7bcfffb2a2463f0e8a7590f638412ae61f79a25fa4a0e5fd572"
    sha256 arm64_linux:   "722ddbc762366d2a8afb36509b663346bc7b06dec34faa7fb3667ee1e520ffd9"
    sha256 x86_64_linux:  "c43ff030cb6b7b4ad38f3be3586d9371ec0442980e9e35de2db8ac033048f4d8"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"

  uses_from_macos "libffi"

  # does not build on macOS 14
  on_macos do
    on_intel do
      depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600

      fails_with :clang do
        build 1600
        cause "Unhandled lisp initialization error"
      end
    end
  end

  patch do
    url "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/59de50b52380132d44bfa05f573544cba0a8c65f.diff"
    sha256 "553982804178fbcc3111474e8ca5319c689141e74c151f3feb6fec78f93ae640"
    type :backport
  end

  def install
    ENV.deparallelize

    libffi_prefix = if OS.mac?
      MacOS.sdk_path
    else
      formula_opt_prefix("libffi")
    end
    system "./configure", "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{formula_opt_prefix("gmp")}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{formula_opt_prefix("bdw-gc")}",
                          "--with-extra-files=#{buildpath}/src/util/side-modules.lsp",
                          *std_configure_args
    ENV["ECL_SIDE_MODULES_PATH"] = "#{HOMEBREW_PREFIX}/lib/ecl-#{version}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
