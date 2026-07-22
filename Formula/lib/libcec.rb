class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.0.0.tar.gz"
  sha256 "fbbda7e659e5f0b0971fa42a0a42c95f893f602aaf5c0043077a91476bb90b7b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a2f85ce7242058e838d66f633131d1fdd3d19dd7fddf1a84f6678db006999e1"
    sha256 cellar: :any,                 arm64_sequoia: "efd0e7facb572876d72798c1b07df84e55ba4af2597645342784e667c9750f50"
    sha256 cellar: :any,                 arm64_sonoma:  "d886ddba0e875d545547820c13cf9b22d5c676253512008c8527aaf95454d3df"
    sha256 cellar: :any,                 arm64_ventura: "be082ac4c53c7d700acb7b5f91e9bb965652c9056e76549d3e067fc734c5794f"
    sha256 cellar: :any,                 sonoma:        "0b819287c07576627c5029b3c57d295ef60fd8e8d8f25d6876b8362c7a03c2db"
    sha256 cellar: :any,                 ventura:       "0995d3ba61e560dd6627fc093301c6f99ae1488b75bc49c182c659ef1dd5091c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "680f4262c03b5a10e88bee7ba827762f84e38d943d68a8d0ca61485738f97128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e8795e972cddb728bd93304f2a97ded54988e0a5a253d13a6a2a683d0e2c2f"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end
