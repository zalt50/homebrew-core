class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.2.tar.gz"
  sha256 "17bd4c2d8a3ac4147a848de6adb7d65c265197e73e4861d7630e145ee4976455"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "3bc4615446b89989e386d7e1c992e23ae0adb243ea5810902a50001d1d4a9282"
    sha256 arm64_sequoia: "d597b94f2322e1a5396490a07e293ba655112c3431a7112e7f772661c1c235b3"
    sha256 arm64_sonoma:  "5cdcbfdf01c7a20a9eb0da57a2c911ea0522b529ee882d9d1aa17b649f20939e"
    sha256 sonoma:        "8e04d74af097f135cf8d5388be909cd94ad0fb841ff7801449515e26a5880ca1"
    sha256 arm64_linux:   "16333b50bc0e8558ec5810f6427eb01a0fc72589913503fb77c248cff8eb103c"
    sha256 x86_64_linux:  "e54b5e6c7d9ce3b71d4b27d3736b5038d7138cc4dd430f0cf023cbb53e44e0c5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  # Drop leftover call to `log_to_syslog`, whose definition was commented out upstream
  patch do
    url "https://github.com/mikebrady/shairport-sync/commit/7bfe78603e8f53f224bef825c7d5dd321ca3e781.patch?full_index=1"
    sha256 "3299dc130e338b0c9cf35b242ac4269d3096fe7398c8a5e77bb671ca95a5e4cf"
    type :backport
    resolves "https://github.com/mikebrady/shairport-sync/pull/2243"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pulseaudio
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{pkgetc}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var/"log/shairport-sync.log"
    error_log_path var/"log/shairport-sync.log"
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-PulseAudio-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-PulseAudio-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end
