class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "e93ea1ddaa5d31ce0907dd83ba1392d9923df72af3b74422fd04338523309db8"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86dd78a8619d0133c1ebeca1cb2a756a437ed2f65dd8e8e6dc79b53c25452e9f"
    sha256 cellar: :any,                 arm64_sequoia: "926d6424760354e0b3261b0271b2ff62ee80b5fcdc7cd4ad68006de9ed9b6848"
    sha256 cellar: :any,                 arm64_sonoma:  "b001f37a0f15f03ac9d89ba0a96d60fcffb78a65ae8f99aa4072fa044feb07be"
    sha256 cellar: :any,                 sonoma:        "4ad66c3652911b4f6b7826a0349556e9e7e64efa3c5639791f6dc97ab8f8fb63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "942d32e8273792f90e4694488abcffa35f91deb8c7ab4462e98e1d9dafeb74ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b413339961fd7bf1b31b3c0cabc39935053a032dbaefef5c040a343e9a48e56"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    commit = build.head? ? Utils.git_short_head : tap.user.to_s
    ldflags = %W[
      -s -w
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.Commit=#{commit}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"

    (var/"tronbyt-server/.env").write <<~EOS
      # Add application configuration here.
      # For example:
      # LOG_LEVEL=INFO
    EOS
  end

  def caveats
    <<~EOS
      Application configuration should be placed in:
        #{var}/tronbyt-server/.env
    EOS
  end

  service do
    run opt_bin/"tronbyt-server"
    keep_alive true
    log_path var/"log/tronbyt-server.log"
    error_log_path var/"log/tronbyt-server.log"
    working_dir var/"tronbyt-server"
  end

  test do
    port = free_port
    log_file = testpath/"tronbyt_server.log"
    (testpath/"data").mkpath
    File.open(log_file, "w") do |file|
      pid = spawn(
        {
          "PRODUCTION"   => "0",
          "TRONBYT_PORT" => port.to_s,
        },
        bin/"tronbyt-server",
        out: file,
        err: file,
      )
      sleep 5
      30.times do
        sleep 1
        break if log_file.read.include?("Listening on TCP")
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
