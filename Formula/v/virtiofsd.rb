class Virtiofsd < Formula
  desc "Vhost-user virtio-fs device backend written in Rust"
  homepage "https://gitlab.com/virtio-fs/virtiofsd"
  url "https://gitlab.com/virtio-fs/virtiofsd/-/archive/v1.14.0/virtiofsd-v1.14.0.tar.bz2"
  sha256 "0646c2cd5a733dd411afb49be8eff7f0a10bb4a286f75b822961e07ea6a654af"
  license all_of: ["Apache-2.0", "BSD-3-Clause"]

  depends_on "rust" => :build
  depends_on "libcap-ng"
  depends_on "libseccomp"
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "socket"

    assert_match version.to_s, shell_output("#{bin}/virtiofsd --version")

    sock = testpath/"virtiofsd.sock"
    shared = testpath/"shared"
    shared.mkpath

    pid = spawn(bin/"virtiofsd", "--shared-dir", shared, "--socket-path", sock,
                "--sandbox", "none", "--log-level", "off")
    begin
      sleep 2
      assert_predicate sock, :socket?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
