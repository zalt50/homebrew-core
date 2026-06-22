class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/linphone-sdk/-/archive/5.5.6/linphone-sdk-5.5.6.tar.bz2"
  sha256 "abde36ececa65bcd9b0241d6baadf7ad185732b3e3ecbd5ccbaffa315e82b926"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "275450c5d1111a7b87419e5bf27f72f0baee3e21aa19443e000d7bb7b8d56e6c"
    sha256 cellar: :any, arm64_sequoia: "d1d661899210b108693bb717e5bdf2cbdfd2f3a6d44cd91545690cbbc50aef1a"
    sha256 cellar: :any, arm64_sonoma:  "4a0629c116780f5a61264ea24146e6b568cc37fbf6223ea7a45fb10c3831de29"
    sha256 cellar: :any, sonoma:        "6f91644e719f7a9938e1638ab7ee93d9fef0dbc8b41727d1203bc940084caa8b"
    sha256 cellar: :any, arm64_linux:   "b2c18d1266e0e66e3f3986ced896229f8dfeb16862e09343360864a001b9d8e5"
    sha256 cellar: :any, x86_64_linux:  "2600e46e3eb6a1410ba4d39563ed5c81c4ed1bb519230f599a2d70390a30cd5a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3" # OpenSSL 4 is not supported in monorepo

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", "ortp", "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end
