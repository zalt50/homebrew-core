class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.11.1.tar.gz"
  sha256 "ee3ffd1c8b7d406cd5610d537a9e033d93e00f5db208ea0341f0dbd0472e486a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3300d0d3c06a6e59a83b74c7126a3ac0c58e16cb3119680eebe96950dcba7a44"
    sha256 cellar: :any, arm64_tahoe:       "28211e7716a723bc05b8e67aed8803d6e3092251ccaca1236d229e99bfa071ab"
    sha256 cellar: :any, arm64_sequoia:     "7802e9fdeea8127613b4900b0462b1ee067f8d409bebf231bad482bc9bc47690"
    sha256 cellar: :any, arm64_linux:       "4cb49bdc4f4d558c6671787f4d5beed9ec4745c6578fa3e1c54e4166b740f8c3"
    sha256 cellar: :any, x86_64_linux:      "185130fc20414a3487e6f5cd879c14b7ef9ec2830286e0879c8582537351a6f7"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/assert_print.h", "test/butterworth.cpp", "test/scipy.cpp",
                              "test/scipy.h", "test/signal.csv", *Dir["test/butterworth-*.csv"]
  end

  test do
    cp (pkgshare/"test").children, testpath
    system ENV.cxx, "-std=c++11", "butterworth.cpp", "scipy.cpp", "-o", "test", "-L#{lib}", "-liir"
    system "./test"
  end
end
