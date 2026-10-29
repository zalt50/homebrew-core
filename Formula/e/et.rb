class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v7.1.0.tar.gz"
  sha256 "6c1eacb22f3465af8edcdd814318e5e23a4cf3b8fc2e50a2525d2b2b3bf44016"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "591601341a4ac7fe17be9f6030d6f750caac91cd566d8a0e104ffc33dcd04b10"
    sha256 cellar: :any, arm64_tahoe:       "6d0947a60d16068937fbb570905945c2c2df1b0d56b6c25d5a04bb2b8a75e0ad"
    sha256 cellar: :any, arm64_sequoia:     "f56a0fbaa20f096c676508d115dc0d49d473b12652d18da61e206d43af7ceabd"
    sha256 cellar: :any, arm64_linux:       "3e47f2720958daafa5e4ae0ad097f862fe36027f7519914e70fd63b6d23dafd4"
    sha256 cellar: :any, x86_64_linux:      "497c4468115550480235663153265c5ed51ac246934592e01e49d0e074546703"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "libsodium"
  depends_on "openssl@4"
  depends_on "protobuf"

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DDISABLE_VCPKG=ON
      -DDISABLE_SENTRY=ON
      -DDISABLE_TELEMETRY=ON
      -DBUILD_TESTING=OFF
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove Windows-specific script
    rm bin/"et1.cmd"

    etc.install "etc/et.cfg"
  end

  service do
    run [opt_bin/"etserver", "--cfgfile", etc/"et.cfg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"log/et/etserver.err"
    log_path var/"log/et/etserver.log"
    require_root true
  end

  test do
    port = free_port
    # Avoid the default `$HOME/.local/share/etserver` fifo directory, whose
    # ancestor checks open `/` for reading and fail inside the Linux sandbox.
    pid = spawn bin/"etserver", "--port", port.to_s, "--serverfifo", testpath/"etserver.fifo", "--logtostdout"

    require "socket"
    Timeout.timeout(60) do
      loop do
        TCPSocket.open("127.0.0.1", port).close
        break
      rescue Errno::ECONNREFUSED
        sleep 1
      end
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
