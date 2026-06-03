class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v5.00c.tar.gz"
  version "5.00c"
  sha256 "b0c005a1d28883ad1cad17ac01837d5c6b0cc7a72d19db700823e42ce3848534"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2b6b831bae1cebc9d380d8700fc2aada2515f9d91bbcde148f6f108aad17f43d"
    sha256 arm64_sequoia: "c00b48ccd7e9abd3a72d6152316b66e791165c5c61dacb6098bf47352cd99553"
    sha256 arm64_sonoma:  "e648a0c06e6b1702976780aa7737a45234a77cfede13e45c2740310076f6457d"
    sha256 sonoma:        "3c8d9f2eb1620db1a59c547ca9b3d1457e310964c9c2b2407cdb9ea1ec6cd26b"
    sha256 arm64_linux:   "1b19ebf6978c87e5fc2a5e59dc7cd8ebfa867933ae30da3d240a61f6b60ce46d"
    sha256 x86_64_linux:  "6e4450ab7a2346c4ec5f68594f22e9b9aadf8b5b702609f34bf887f3719fe623"
  end

  depends_on "coreutils" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    llvm = Formula["llvm"]
    make_args = %W[
      PREFIX=#{prefix}
      CC=clang
      CXX=clang++
      LLVM_BINDIR=#{llvm.opt_bin}
      LLVM_LIBDIR=#{llvm.opt_lib}
    ]

    system "make", "source-only", *make_args
    system "make", "install", *make_args
    return unless llvm.keg_only?

    bin.env_script_all_files libexec, PATH: "#{llvm.opt_bin}:${PATH}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~CPP
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    CPP

    system bin/"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
