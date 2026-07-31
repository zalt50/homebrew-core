class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.3.tar.gz"
  sha256 "c7b208433418991a9ae7af1d43ffebf99ddc27ee7119a2794f19dcc02e4568b1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ffed930cc2e3d378ae9496352deffd71b99ed8d2ed794c6b3122635fdb9bf101"
    sha256 cellar: :any, arm64_sequoia: "57f67e4e588df97d8cb82563ab7f6a1baac0832d549c2b4af007d83a71c33612"
    sha256 cellar: :any, arm64_sonoma:  "0bf3502f9fe05a306fd2d179c815f4c34b3e903131b8629a952b6aec69f48f26"
    sha256 cellar: :any, sonoma:        "753edba0108f394d5891b0ca85fef80260ccddc7e53a5d2f143c7ac94419cb33"
    sha256 cellar: :any, arm64_linux:   "4dcb1fa58b708559fe3a4d987555656a97e71026af4b070f3207b002cf3f377e"
    sha256 cellar: :any, x86_64_linux:  "fb7cff8da4049fa3324c2df783dd06497968af46b37d1419f4cc190797add5ef"
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
