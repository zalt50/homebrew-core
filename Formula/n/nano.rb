class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v9/nano-9.0.tar.xz"
  sha256 "9f384374b496110a25b73ad5a5febb384783c6e3188b37063f677ac908013fde"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0a983eefbaf98e0b9d1fe9fec31c8e573777a080b86521c2d121a9a0e5831890"
    sha256 arm64_sequoia: "78489eb5b719a880ae4df40db133de2cbbc68f6eb3821b84612ee83b4f172a5f"
    sha256 arm64_sonoma:  "f3e7bf555bdbf2f76cb746dc35e6e7bf87bbaf0be01ce84cbadf8413674493da"
    sha256 sonoma:        "f85eabd5621465c91b3e370005d3363ab5738b174b58ebb5123fda6ddc293ab8"
    sha256 arm64_linux:   "2302672047e0fb5c5ab0ff0cdde437ffff60f030a781e848915fce42ebc16638"
    sha256 x86_64_linux:  "a3f04be362cea9da1cecebc05035784a8c68cd9224951bdfb6da5953bf15b102"
  end

  head do
    url "https://git.savannah.gnu.org/git/nano.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "groff" => :build
    depends_on "texinfo" => :build

    on_linux do
      depends_on "gettext" => :build
    end
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libmagic"
  end

  def install
    if build.head?
      # `aclocal --print-ac-dir` returns automake's versioned path
      # which fails the check for `pkg.m4` since it is not there
      inreplace "configure.ac", "$(aclocal --print-ac-dir)", HOMEBREW_PREFIX/"share/aclocal"
      system "./autogen.sh"
    end

    system "./configure", "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"

    # Replace versioned paths from `sample.nanorc`
    brew_pkgshare = HOMEBREW_PREFIX/"share"/name
    inreplace "doc/sample.nanorc", pkgshare, brew_pkgshare
    # Copy sample so we can install a default configuration in `etc` as well
    cp "doc/sample.nanorc", "nanorc"
    doc.install "doc/sample.nanorc"

    # Enable syntax highlighting files (including extras) by default
    pkgshare.install Dir[pkgshare/"extra/*"]
    inreplace "nanorc", %r{^# (include #{brew_pkgshare}/\*\.nanorc)$}o, "\\1"
    etc.install "nanorc"
  end

  def caveats
    <<~EOS
      A sample configuration file is available at
        #{HOMEBREW_PREFIX}/share/doc/#{name}/sample.nanorc

      See `man nanorc` for more information.
    EOS
  end

  test do
    system bin/"nano", "--version"

    # Skip test on Intel macOS due to CI failures
    return if OS.mac? && Hardware::CPU.intel?

    PTY.spawn(bin/"nano", "test.txt") do |r, w, _pid|
      sleep 1
      w.write "test data"
      sleep 1
      w.write "\u0018" # Ctrl+X
      sleep 1
      w.write "y"      # Confirm save
      sleep 1
      w.write "\r"     # Enter to confirm filename
      sleep 1
      OS.mac? && r.read
    end

    assert_match "test data", (testpath/"test.txt").read
  end
end
