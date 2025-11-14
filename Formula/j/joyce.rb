class Joyce < Formula
  desc "Emulates the Amstrad PCW on Unix, Windows and Mac OS X"
  homepage "https://www.seasip.info/Unix/Joyce/index.html"
  url "https://www.seasip.info/Unix/Joyce/joyce-2.4.2.tar.gz"
  sha256 "85659a6ac9b94fdf78c28d5d8d65a4f69e7520e1c02a915b971c2754695ab82c"
  license "GPL-2.0-or-later"

  depends_on "libdsk"
  depends_on "libpng"
  depends_on "sdl12-compat"

  uses_from_macos "libxml2"

  def install
    # At the moment Joyces uses and bundles libdsk-1.5.x (dev)
    # while homebrew provides libdsk-1.4.x (stable) so we cannot
    # use the system's libdsk and we need to remove/not link
    # conflicting files.
    # system "./configure", "--disable-silent-rules", "--with-system-libdsk", *args
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    # Remove conflicting files with bundled libdsk
    %w[apriboot dskdump dskform dskid dskscan dsktrans dskutil md3serial].each { |f| rm bin/f }
    rm lib/"libdsk.a"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xjoyce --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"xjoyce", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "JOYCE will emulate a PCW 82048 (or 92048)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
