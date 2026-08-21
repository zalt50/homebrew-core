class Rtp2httpd < Formula
  desc "Multicast RTP/RTSP-to-HTTP converter with web player and status dashboard"
  homepage "https://rtp2httpd.com"
  url "https://github.com/stackia/rtp2httpd/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "406bd58db75eae446100fdf1af63d63401065c460cdb74bb2d5622154b8ae737"
  license "GPL-2.0-only"
  head "https://github.com/stackia/rtp2httpd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3bbc6a6a9d7e5337b39a6d264a12bf97f3f55eb6a1538c6703c767adabc5f9de"
    sha256 arm64_sequoia: "b9a65994905f4dcc157c3371b052716bb2a17655d9a334fdeb312cac5bbc7d81"
    sha256 arm64_sonoma:  "fb393037b61b25b7ff7c8e6eacdfffbc82cb25efcbf874d8a4540a5a0751ea7c"
    sha256 sonoma:        "182472c1d4806d31f72dac74eed50aabba8bac3e7da44c4816063575dd4c5f15"
    sha256 arm64_linux:   "4861ad495bfcca93d07dd7bd58759ed235c2b257d2a0f0726f24f80b35dfcd35"
    sha256 x86_64_linux:  "fcfeb04ebde4b1b67018129625949b5ebdba08c952fe8d6971314e1a19daa253"
  end

  depends_on "cmake" => :build

  def install
    ENV["RELEASE_VERSION"] = version.to_s

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DENABLE_AGGRESSIVE_OPT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"rtp2httpd", "--config", etc/"rtp2httpd.conf",
         "--pid-file", var/"run/rtp2httpd.pid"]
    keep_alive true
    log_path var/"log/rtp2httpd.log"
    error_log_path var/"log/rtp2httpd.log"
  end

  test do
    port = free_port
    pid = spawn bin/"rtp2httpd", "--noconfig", "--listen", "127.0.0.1:#{port}"
    sleep 2

    assert_match "rtp2httpd", shell_output("curl --silent http://127.0.0.1:#{port}/status")
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
