class Keyd < Formula
  desc "Key remapping daemon for Linux"
  homepage "https://github.com/rvaiya/keyd"
  url "https://github.com/rvaiya/keyd/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "697089681915b89d9e98caf93d870dbd4abce768af8a647d54650a6a90744e26"
  license "MIT"
  head "https://github.com/rvaiya/keyd.git", branch: "master"

  depends_on :linux

  def install
    args = %W[
      PREFIX=#{prefix}
      CONFIG_DIR=#{etc}/keyd
    ]
    system "make", *args, "SOCKET_PATH=#{var}/run/keyd.socket"
    system "make", "install", *args
  end

  service do
    run [opt_bin/"keyd"]
    keep_alive true
    require_root true
    log_path var/"log/keyd.log"
    error_log_path var/"log/keyd.log"
  end

  def caveats
    <<~EOS
      Default configuration goes in #{etc}/keyd/default.conf
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyd --version")

    # Verify check command works with a valid config
    (testpath/"test.conf").write <<~CONF
      [ids]
      *

      [main]
      capslock = esc
    CONF
    assert_match "No errors found", shell_output("#{bin}/keyd check #{testpath}/test.conf")
  end
end
