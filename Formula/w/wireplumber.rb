class Wireplumber < Formula
  desc "Session / policy manager implementation for PipeWire"
  homepage "https://pipewire.pages.freedesktop.org/wireplumber/"
  url "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.18/wireplumber-0.5.18.tar.bz2"
  sha256 "0c2ea30a7b3bb4ecad456bb27e2c283defda59bb53d97df6917a495f12887e33"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "3d485817124add0e1a5846238db2c7240b8501bdc67442f0781c45b741864f81"
    sha256 x86_64_linux: "1017d89becd684b64955ae3567628f199a60b4ccce7ff5405855c8164f77c2d2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "dbus" => :test

  depends_on "glib"
  depends_on :linux
  depends_on "lua"
  depends_on "pipewire"
  depends_on "systemd"

  def install
    args = %W[
      -Ddoc=disabled
      -Dsysconfdir=#{etc}
      -Dsystem-lua=true
      -Dtests=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    ENV["XDG_DATA_DIRS"] = testpath # avoid loading system dbus services
    ENV["XDG_RUNTIME_DIR"] = testpath
    ENV["DBUS_SESSION_BUS_ADDRESS"] = address = "unix:path=#{testpath}/bus"
    dbus_pid = spawn(formula_opt_bin("dbus")/"dbus-daemon", "--session", "--nofork", "--address=#{address}")
    sleep 5
    pipewire_pid = spawn(formula_opt_bin("pipewire")/"pipewire")
    sleep 5
    assert_match "PipeWire 'pipewire-0'", shell_output("#{bin}/wpctl status")
  ensure
    [pipewire_pid, dbus_pid].each do |pid|
      next unless pid

      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
