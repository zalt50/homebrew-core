class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.4.0.tar.gz"
  sha256 "6fc96177d194bfe393b9522b127df30f6d5ce4a2a403ba63eff0387278126957"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cbbb5007f86886a61ee4d3af71b15ec31b9c0c10288d76151f73fe59530db5cc"
    sha256 cellar: :any, arm64_sequoia: "41cff78298f1fa52ab4f39f7e91b94d43b4c3c18dffe9364adb7a0648c008106"
    sha256 cellar: :any, arm64_sonoma:  "a7f8717adf1e19cce628ad0d5b5d9f95fc4d97764080a49e2f88faf4423ed688"
    sha256 cellar: :any, sonoma:        "b0753af88a70466f5f4f9636c53ef391c4caf78ac2a975a7f5798453c27a33d1"
    sha256 cellar: :any, arm64_linux:   "cd01ba32906b0bf5eeffe70a7aff115eb88981994bfb5d42e2aaa64edf931629"
    sha256 cellar: :any, x86_64_linux:  "5dac96238f3d553a15170f9beecee62dec167311a6cb10e1d86aababc2a3db49"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memtier_benchmark --version")
    assert_match "ALL STATS", shell_output("#{bin}/memtier_benchmark -c 1 -t 1")
  end
end
