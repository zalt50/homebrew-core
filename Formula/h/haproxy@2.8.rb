class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.25.tar.gz"
  sha256 "2189aa5baba98e4cf6e9e8c0633d88426eaf3fa1017b2a6061512f11fbc6d856"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fd12c7f6a1c406e62529412343bfdfb0720db223780325be612ba2fe19b2761"
    sha256 cellar: :any,                 arm64_sequoia: "29896059bfaa72f58a7ff0495c9ed14953d711084f1a0c3f0feecea3f305554f"
    sha256 cellar: :any,                 arm64_sonoma:  "82a559a792a25177d53f473ca91d41ee937ac5fc0a24d97d1e1c98ed19c7da98"
    sha256 cellar: :any,                 sonoma:        "c40ec814719f924c1d30239adc947a7aefb4aef2a89a34638116971e810dcb70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43107cdf32cf4af5bfdab3f0cb5c9b97a4e27f59354e4db02c3090206217eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df118e96f79175dd47e67c09293ed8da748779f0c83927aef571a6a735ae657"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_ZLIB=1
    ]

    target = if OS.mac?
      "osx"
    else
      "linux-glibc"
    end
    args << "TARGET=#{target}"

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  service do
    run [opt_bin/"haproxy", "-f", etc/"haproxy.cfg"]
    keep_alive true
    log_path var/"log/haproxy.log"
    error_log_path var/"log/haproxy.log"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
