class Ratty < Formula
  desc "GPU-rendered terminal emulator with inline 3D graphics"
  homepage "https://ratty-term.org/"
  url "https://github.com/orhun/ratty/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8d48b5c6adfc8543ed649a53221b61df129da415298c7875557c4fcb56255806"
  license "MIT"
  head "https://github.com/orhun/ratty.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "wayland"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "config"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ratty --version")

    # No logs on Linux
    return if OS.linux?

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ratty", [:out, :err] => output_log.to_s
      sleep 1
      expected = Hardware::CPU.arm? ? "Apple Paravirtual device" : "Unable to find a GPU"
      assert_match expected, output_log.read if OS.mac?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
