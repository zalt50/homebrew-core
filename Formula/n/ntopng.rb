class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  url "https://github.com/ntop/ntopng/archive/refs/tags/6.6.tar.gz"
  sha256 "2e97fbd26c2f9ac526214e2a2e22ecb218e38f5e99a688c25ae6cedbbc3a892c"
  license "GPL-3.0-only"
  head "https://github.com/ntop/ntopng.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "923d0cf57bfd6c48d12465ce81b821249850791702162a9d10a6f6ea73ed79f6"
    sha256 arm64_sequoia: "1b62120513879ce4cb6ba349d4ac92223089a6c77e6d6719df29250f61954a7b"
    sha256 arm64_sonoma:  "40dffa8af2e27119e1ee18f2808f3578f71a437968fb8178e78c80bdb2dac34c"
    sha256 arm64_ventura: "0fb6b854e3a12b0023d73b05c5f8241bd345d0811fa67e62606e5306ee2646be"
    sha256 sonoma:        "0f136bffdd96b2f2265f6215872b75b532ed4119035f54e6929fc61ede54983d"
    sha256 ventura:       "eebfd0cc2d9bf8fcd50ad648370c995967c73a820eb7077c4b335d6567bbc20f"
    sha256 arm64_linux:   "8c3a45211d5d3e9fca45b73ae7d94d5c4929b1a11825d26fcae495dbb5d97bbd"
    sha256 x86_64_linux:  "4b68256ead71268544621f9d21828f0fade161f54f6ba3dc3803d28f20bda3fc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "valkey" => :test

  depends_on "hiredis"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "libsodium"
  depends_on "mariadb-connector-c"
  depends_on "ndpi"
  depends_on "openssl@3"
  depends_on "rrdtool"
  depends_on "sqlite"
  depends_on "zeromq"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "zstd"
  end

  on_linux do
    depends_on "libcap"
  end

  resource "clickhouse-cpp" do
    url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.0.tar.gz"
    sha256 "f694395ab49e7c2380297710761a40718278cefd86f4f692d3f8ce4293e1335f"
  end

  def install
    # Remove bundled libraries
    rm_r Dir["third-party/{json-c,rrdtool}*"]

    resource("clickhouse-cpp").stage buildpath/"third-party/clickhouse-cpp"

    args = %W[
      --with-dynamic-ndpi
      --with-ndpi-includes=#{Formula["ndpi"].opt_include}/ndpi
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make", "install", "MAN_DIR=#{man}"
  end

  test do
    valkey_port = free_port
    valkey_bin = Formula["valkey"].bin
    spawn valkey_bin/"valkey-server", "--port", valkey_port.to_s
    sleep 10

    mkdir testpath/"ntopng"
    spawn bin/"ntopng", "-i", test_fixtures("test.pcap"), "-d", testpath/"ntopng", "-r", "localhost:#{valkey_port}"
    sleep 30

    assert_match "list", shell_output("#{valkey_bin}/valkey-cli -p #{valkey_port} TYPE ntopng.trace")
  end
end
