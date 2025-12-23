class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "785867e7e84b62497df4346e9ec7f402bc495532a4df7624b5aa199ec337935d"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2abc50ddf450310e259a0c96158706e8cdde12fb9e9730e9e5ab76ad2ce6fb40"
    sha256 cellar: :any,                 arm64_sequoia: "0b9d5e001f84ea4d411766a35d235c2028cee58be7464ad6572e6178cd187901"
    sha256 cellar: :any,                 arm64_sonoma:  "31cfe7c54eb8bf45cb2218ff23fb0f073aef847b218de9bc491611edb3836aed"
    sha256 cellar: :any,                 sonoma:        "e42d555585c5c621ee39f717f39e887fdc411e47294ec7752280504ba47cb13b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49b31d97fe3cc84cec4ad6ad7aaeaf81e2921d18e3bacd5a0ee7e8d8a0e344a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb2b2a67ea78646c53edb69ece17ae068e18558c7bd0188fb4bfcabd0d9dd789"
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
