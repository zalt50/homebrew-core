class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  url "https://github.com/hercules-team/augeas/releases/download/release-1.15.0/augeas-1.15.0.tar.gz"
  sha256 "95b2b5c4c10c964024c694d6349024e8033dcfa1aaba88884ea09394908d30ff"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "2273d25a4b0318c88c3b8ffd44e40ff0b48550d771165ff21e0543b0aeb7b9a4"
    sha256 arm64_tahoe:       "2892b23195b7b47069e656f53c2421e7d7a72b2bf52e155e88bb2deebdb5aaeb"
    sha256 arm64_sequoia:     "bce63494ef71096631916e4dc8c8ba4f38de70df2ab997a448db5143e7b16615"
    sha256 arm64_sonoma:      "8d377f15f9e15f40c3ca6b3de2afbdeeb808c08dfa9a89903a8b36c0f0bc2b23"
    sha256 sonoma:            "460c292b7c6a2e2a3f4bb98b468830a491792e82c92f8f688124903674d7f92c"
    sha256 arm64_linux:       "5ce934dec1d8de104c5347895c95f02c5f0965145474cdef866dd9a512c497ab"
    sha256 x86_64_linux:      "ba562790d6783f698cb827068f53004f5fa2c72e61217c378b5f83ff7f4cc1d9"
  end

  head do
    url "https://github.com/hercules-team/augeas.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("readline")}"

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/augtool --version 2>&1")

    (testpath/"etc/hosts").write <<~EOS
      192.168.0.1 brew.sh test
    EOS

    assert_equal <<~EOS, shell_output("#{bin}/augtool --root #{testpath} 'print /files/etc/hosts/1'")
      /files/etc/hosts/1
      /files/etc/hosts/1/ipaddr = "192.168.0.1"
      /files/etc/hosts/1/canonical = "brew.sh"
      /files/etc/hosts/1/alias = "test"
    EOS

    assert_equal <<~EOS, shell_output("#{bin}/augprint --lens=hosts --target=/etc/hosts #{testpath}/etc/hosts")
      setm /augeas/load/*[incl='/etc/hosts' and label() != 'hosts']/excl '/etc/hosts'
      transform hosts incl /etc/hosts
      load-file /etc/hosts
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/ipaddr '192.168.0.1'
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/canonical 'brew.sh'
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/alias 'test'
    EOS
  end
end
