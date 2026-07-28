class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2026_07_28.f8df3f1.tar.xz"
  version "2026_07_28.f8df3f1"
  sha256 "fcfeb5fbdf775bcc48edc1d5eac8a6d57bc333f8e67b714149376d36061416f0"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "6de464011e3196ce6ef8b503200ab4ce9f850ad247e8855004cca354b9182ff7"
    sha256 cellar: :any, x86_64_linux: "45d37d2406e8759bab4032c6fd8725525c823951f2c7ea75ca3e7d90ff2bf6c2"
  end

  depends_on :linux

  def install
    args = ["prefix=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    require "pty"
    PTY.spawn("#{bin}/passt --version") do |r, _w, _pid|
      sleep 1
      assert_match "passt #{version}", r.read_nonblock(1024)
    end

    pidfile = testpath/"pasta.pid"
    begin
      # Just check failure as unable to use pasta or passt on unprivileged Docker
      output = shell_output("#{bin}/pasta --pid #{pidfile} 2>&1", 1)
      assert_match "Couldn't create user namespace", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end
