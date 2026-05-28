class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.7.0.tar.gz"
  sha256 "193a5b182642952eecc8aee162324b27b227fd57527b6f71297d428a664674e1"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d898fb3ede780ca246054d1675db73ea9f1e959c589cc11b4fb950504db6325"
    sha256 cellar: :any,                 arm64_sequoia: "e010fe936044545ca967b333b8aa8b070b4cd0bb1f62397e653b5b33bed1b101"
    sha256 cellar: :any,                 arm64_sonoma:  "76790a61513fbea2c785817d20f3e291dedc4498715d66ec2ab31503cc8a5507"
    sha256 cellar: :any,                 sonoma:        "7ea1c64b4a61e8bef1d52603169419784eeea83c168c1582c1b74c42c6db80d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f0c5a7bf7a46c48de87ac1fdc1ae974c8a20468e142f3f97436fa210852666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab319c8808024515852af04a7384ff64d16b1668fd34004eb5a4bdb4aaf52248"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libidn2"
  depends_on "libmaxminddb"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      Address        = 1.1.1.1
                          \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network        = 1.1.1.1 / 32
      Netmask        = 255.255.255.255
      Broadcast      = not needed on Point-to-Point links
      Wildcard Mask  = 0.0.0.0
      Hex. Address   = 01010101
      Host Bits      = 0
      Max. Hosts     = 1   (2^0 - 0)
      Host Range     = { 1.1.1.1 - 1.1.1.1 }
      Properties     = \

         - 1.1.1.1 is a HOST address in 1.1.1.1/32
         - Class A
      DNS Hostname   = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end
