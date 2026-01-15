class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "ae8724336e9ad1c2e8e3bab4bdd2c832db850b6ab8acb5e1ebaee634574b91fa"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f2e5bedb18fde82125b29a27b86d572025ca9beaede0801dd9662e140e9bb5e"
    sha256 cellar: :any,                 arm64_sequoia: "5c4cf81ec584742656f7ccbd0ec41d24eeb566c61240de89793c8c89e419d467"
    sha256 cellar: :any,                 arm64_sonoma:  "243c72500446af456d8c3d2beca72347a3538641fe1e41c462bf197c9a8f5777"
    sha256 cellar: :any,                 sonoma:        "4d2ea5f9a52dd426b31ae17843fb9646979c8439f9110a6c6b2a785f2e5b1929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f31e2b5743be47bcd5ae7e7a73e324f88dd3c26f7b2497467934f2eb7d000779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "784e0a8319aa84cb20030aaa971fa7c8dd01dadf3750fa062f029ad356954b67"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    ldflags << "-X tronbyt-server/internal/version.Commit=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  def post_install
    (var/"tronbyt-server").mkpath
    dot_env = var/"tronbyt-server/.env"
    dot_env.write <<~EOS unless dot_env.exist?
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
