class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.6.tar.gz"
  sha256 "e1e762fee8589def3cbceb1f3e53ba06ed5b557a2705b86a225f8f30fb19c79a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "958abd97dc9e2f1df35d8f2caf656be43e0c12c94901569f3a547f526e08e179"
    sha256 cellar: :any, arm64_sequoia: "db5e4f6cf19bbec4f18aeac4d18865891235e17a41f0eaa9f15f20bb4ee66110"
    sha256 cellar: :any, arm64_sonoma:  "c7f9bc544aecfb6f352d493b053e1cc12892ce959d71a1cfb798fa00ac1a3cfb"
    sha256 cellar: :any, sonoma:        "93c13b618d2ecd5af1cd5c0cd2678cb6678888a088c3266a94ff03c529df4e53"
    sha256 cellar: :any, arm64_linux:   "dd754b3dae3b23fe883a568e5c6e6f319415a029869e7f93f55a5b90de0aec5f"
    sha256 cellar: :any, x86_64_linux:  "1f357f08f8258888f32f15af3c7353c617e9ccce148d5a35c62868eb7405d509"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end
