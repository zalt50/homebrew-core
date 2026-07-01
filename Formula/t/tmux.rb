class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.7a/tmux-3.7a.tar.gz"
  sha256 "8ee44ce951182845fd57ad12dd6f27fb677b1afb900e2e84df4798112ed0dbf0"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "208a851696b7c89f3732be6f181827f1fc643412cfda47febc328715b30ecfc7"
    sha256 cellar: :any, arm64_sequoia: "653de3a14143f6c70022715f182205686eae480529090dcd281ee5be985db514"
    sha256 cellar: :any, arm64_sonoma:  "85da7ff24fe3879145396dd52b7ad075af9614d00d3d6b3045b31bfc300d6880"
    sha256 cellar: :any, sonoma:        "2b5dc6fc996fbff37e79f2211ccd8fd50e154d60fc71e172588a32ba73d5f68a"
    sha256 cellar: :any, arm64_linux:   "1365d28084623a41dab4d6df698a091b87233d9d7bc3b8a97dfb05de05f95e89"
    sha256 cellar: :any, x86_64_linux:  "5ef22e6c491aa40e24c8e16512bdca64f5ee5fca2546ff635635c2bac83c94f9"
  end

  head do
    url "https://github.com/tmux/tmux.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  uses_from_macos "bison" => :build # for yacc

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]

    # tmux finds the `tmux-256color` terminfo provided by our ncurses
    # and uses that as the default `TERM`, but this causes issues for
    # tools that link with the very old ncurses provided by macOS.
    # https://github.com/Homebrew/homebrew-core/issues/102748
    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma

    system "./configure", *args, *std_configure_args
    system "make", "install"

    pkgshare.install "example_tmux.conf"
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system bin/"tmux", "-V"

    require "pty"

    socket = testpath/tap.user
    PTY.spawn bin/"tmux", "-S", socket, "-f", File::NULL
    sleep 10

    assert_path_exists socket
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}/tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end
