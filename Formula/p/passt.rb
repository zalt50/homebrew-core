class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2026_07_16.090d739.tar.xz"
  version "2026_07_16.090d739"
  sha256 "e7ce7a7964826292ccc4d5cdd4402d54268f0eca352b9f06cb73a40e637af52e"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "2866debf7ebd4a6869eb8f4e676bafab5b3310ead5c2a8277fe43585a69dec62"
    sha256 cellar: :any, x86_64_linux: "3086a4a7337f4fee93fa9be4868d07ca69b378b57dbc2760974e315a3b61d7a9"
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
      assert_match "Failed to set up tap device in namespace", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end
