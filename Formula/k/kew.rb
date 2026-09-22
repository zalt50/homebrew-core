class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "1d89ea7391f08d535bb45aafa877cea2efd410f2d1b7e010e85ef70b0de12add"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "5d429f180fbbc5897336fe9884d06ca42ef7b7e3c41dc55c953dda93e2b7fca1"
    sha256 arm64_tahoe:       "338fa91af37cff1d9f8bfcd7f95e8ec15534eac32b94e3d85a2064415c1b2079"
    sha256 arm64_sequoia:     "78c733207a816d72f2137acbad833b73acaa070d766122938f9736b62306f399"
    sha256 arm64_linux:       "0ec8f789219a63fc26d482ee6a24cafb629a61a592e818e6ae29a51226acafc0"
    sha256 x86_64_linux:      "f534be169299898d4c97828e7e91331be3a59e012ece8a7fa09ba294755af8b4"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"

    (testpath/".config/kew").mkpath
    (testpath/".local/state").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    # `kew` puts the terminal in raw mode, so it needs to own a PTY to avoid `SIGTTOU`
    output = ""
    PTY.spawn(bin/"kew", "song") do |r, _w, _pid|
      r.winsize = [40, 120]
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "No Music found.", output
    assert_match "Please make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
