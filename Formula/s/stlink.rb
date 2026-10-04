class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/stlink-org/stlink"
  url "https://github.com/stlink-org/stlink/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "10d6c3bff3d5a7f6aefd00e096339822cafc65acf32e43c842369e346d2e5069"
  license "BSD-3-Clause"
  head "https://github.com/stlink-org/stlink.git", branch: "testing"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "9770b0567094b4aa250b45f7c3ccc7066db3a0a985b97ed595fa8aed6838ea4a"
    sha256 arm64_tahoe:       "a1318d007d2ebd3a5efac196e4c2be465b0bb7a4f6b7b937211d17ad447d983e"
    sha256 arm64_sequoia:     "74429f7151b0a5f5ec7e8f150dadcaad6fc89c8c100edbada6360195e257322c"
    sha256 arm64_sonoma:      "f446d762cfa087474e6c4110af9cfd1764501715b1f6e6c67e73f66950a4ab08"
    sha256 sonoma:            "535d44df1d077f72e893542b763d70fd8cb527dd23801e9bea188146f2f4b7e8"
    sha256 arm64_linux:       "3acecdba1528f1b3be80a7323eee6810539ef12e53943db52ee2806354e9d4a8"
    sha256 x86_64_linux:      "08e0054f6e1ecf8c7298ca5938e79b3d9533d2ddbcc90585adf1303bf2ef0423"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  deny_network_access!

  def install
    libusb = Formula["libusb"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-#{libusb.version.major_minor}
      -DLIBUSB_LIBRARY=#{libusb.opt_lib/shared_library("libusb-#{libusb.version.major_minor}")}
    ]
    if OS.linux?
      args << "-DSTLINK_MODPROBED_DIR=#{lib}/modprobe.d"
      args << "-DSTLINK_UDEV_RULES_DIR=#{lib}/udev/rules.d"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Upstream also installs the shared library to bin, which is only needed for Windows DLLs
    rm(bin.glob("libstlink*"))
  end

  test do
    assert_match "st-flash #{version}", shell_output("#{bin}/st-flash --debug reset 2>&1", 255)
  end
end
