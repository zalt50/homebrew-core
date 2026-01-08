class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-6.1.0.tar.xz"
  sha256 "7921df7507286d90574bbf5ae664a8a537805ce40b5fa8b15f5d0d33e2c438d0"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://www.knot-resolver.cz/download/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t[^>]*?>[^<]*?stable/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9e44459144e302ddff3e540e41acdabb6e68ed34806c43418c5522c167f38d7b"
    sha256 arm64_sequoia: "0c85192ced537fbc923d854fd0fa412a1545442569671cd1b55ea3d37d6682c1"
    sha256 arm64_sonoma:  "511d002a922badc09c9315759ed421787c97cba93470fb0937d14ac947247390"
    sha256 sonoma:        "7336af600e273d721401ad19b52192338e67bb274c97db745a634875c87f1476"
    sha256 arm64_linux:   "3677f7ae2b3b37021ae11b7154149a010c8411e26d6c8f097b14d1162a6f3619"
    sha256 x86_64_linux:  "6f95139bf1ac0f3c31033ac2dab02a2f73842f227c22b7ed2ffe4365047ba634"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"
  depends_on "protobuf-c"

  uses_from_macos "libedit"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = []
    args << "-Dsystemd_files=enabled" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    (var/"knot-resolver").mkpath
  end

  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    require_root true
    working_dir var/"knot-resolver"
    input_path File::NULL
    log_path File::NULL
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
