class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.softhsm.org/"
  license "BSD-2-Clause"
  head "https://github.com/softhsm/SoftHSMv2.git", branch: "main"

  stable do
    url "https://github.com/softhsm/SoftHSMv2/archive/refs/tags/2.7.0.tar.gz"
    sha256 "be14a5820ec457eac5154462ffae51ba5d8a643f6760514d4b4b83a77be91573"

    # OpenSSL 4.0 support was added with memory leak fixes
    patch do
      url "https://github.com/softhsm/SoftHSMv2/commit/57e10cbbe75069be92c7e9720c180a05833481fc.patch?full_index=1"
      sha256 "d60af158e0fcbb72458292b86455ec949d4c550cd009274841cbe94b4ded06dd"
      type :backport
    end
    patch do
      url "https://github.com/softhsm/SoftHSMv2/commit/d23ea09d318c03c033420d065f1c64b019cc94ed.patch?full_index=1"
      sha256 "b8f13d1d584c39d0c04443d756fdb7dadbfe8ab056dd7d290313afcfd93d96ca"
      type :backport
    end
  end

  bottle do
    sha256 arm64_golden_gate: "58fa7501c31030a2f3670573e44eb1ea008ac9144030e3a62050be18347d31cd"
    sha256 arm64_tahoe:       "0cdbf21ef15f1c4cc7098755e89b03acb4fb0b45e9890dc38d5ad67f7069429b"
    sha256 arm64_sequoia:     "f6eb3e1465e04207141332c8733b63bde9b1597958839dccddab34207d1c1fcf"
    sha256 arm64_sonoma:      "30f2b38120d68d5cd515f5a4e48a999424689e43a61929e443d9886b4d0bcc69"
    sha256 sonoma:            "3ad3252a2e79d9cfcdcf9b43874a19fa666900f5f6dc2fd314f3d986cd395279"
    sha256 arm64_linux:       "17a0a35b3e2e99a8ad74b559de10634b4f5385f1c881fd581b5c6bb4b1cf1196"
    sha256 x86_64_linux:      "0a919b81ca6e41a6110d02eb537ae41754ad9d4af09167a4fcb71c52bc788ccc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{pkgetc}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "--disable-gost",
                          *std_configure_args
    system "make", "install"

    (var/"lib/softhsm/tokens").mkpath
  end

  test do
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = testpath/"softhsm2.conf"
    system bin/"softhsm2-util", "--init-token", "--slot", "0",
                                "--label", "testing", "--so-pin", "1234",
                                "--pin", "1234"
    system bin/"softhsm2-util", "--show-slots"
  end
end
