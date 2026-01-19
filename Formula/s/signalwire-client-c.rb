class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "4ce196a4bb886854dfcb9018c05b466484a19f71a50c3d5a990a88429e74163a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2aceb796bbefcfcee258125049f9e3921597fe650daed375bdbcdf83e6e90c61"
    sha256 cellar: :any,                 arm64_sequoia: "27076754d1e4589727339146b931cc3f43d05dd99645e22239819d23f7db67b1"
    sha256 cellar: :any,                 arm64_sonoma:  "725482ec8c26018912db30839afd8681b9be1bae23b7818e0a8250eba8f3edd6"
    sha256 cellar: :any,                 sonoma:        "ee751cfa7b26fc1225f4c13211851bce4f92219c2ec70521b713c6f4788dc812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "804d9d853a4686dbb9066b8e64374c365c959414adf49158dbfdd33a71e26211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b054215f2df6b19d9767c779b338f0f122cd4833c048a3924729d03e8e426ecd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libks"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    # https://github.com/signalwire/signalwire-c/blob/master/examples/client/main.c
    (testpath/"test.c").write <<~C
      #include "signalwire-client-c/client.h"

      int main(void) {
        swclt_init(KS_LOG_LEVEL_DEBUG);
        swclt_shutdown();
        return 0;
      }
    C

    modules = ["signalwire_client#{version.major}", "libks#{Formula["libks"].version.major}"]
    flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", *modules).chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
