class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "1d60b5c78631bbea49bf8201234c15ff9c7e9f2df18d97d27080c8922eae3e13"
  license "BSD-3-Clause"
  head "https://github.com/ledger/ledger.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7afc1dd1857bd994826c06d94c004b114ef6ec065bcd4c35c98a75de1ca5c286"
    sha256 cellar: :any,                 arm64_sequoia: "4923f6555416d2313dbef28d90aacff867b85050caee62de74d326153caeb5b0"
    sha256 cellar: :any,                 arm64_sonoma:  "ffa87e96797ac02677bc7bb94377240d418d8da7c136b9f4982140ebeb4d1b65"
    sha256 cellar: :any,                 sonoma:        "4bd58b8c7413e68a27169e4be6472474dfa7408ec5e2e0f79902c38491fae72a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "581cd827ed09b61e812177c58748bf0e05e1d8839125c4f0b5327a3c179359b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18475b1dd07eef63279f5fb596563e2a420aecbc7c60be38142220658e6acbfe"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "gpgmepp"
  depends_on "mpfr"
  depends_on "python@3.14"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
      -DUSE_GPGME=1
      -DCMAKE_CXX_STANDARD=14
    ] + std_cmake_args

    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash" => "ledger"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", pkgshare/"examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
  end
end
