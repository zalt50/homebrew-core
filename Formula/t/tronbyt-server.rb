class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "746546e74c8e22bf0e6c7f0ac0addc9efa549448aed30e1a0f7834a62b8442b8"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57236435ef65f522f521066e21a15dcba6b6c0b9ec4aadeefd838a5195dd11c1"
    sha256 cellar: :any,                 arm64_sequoia: "1df840276ff647b9aa29072238d3732f1effe1c65d8642ea1d8adbb83eec2d55"
    sha256 cellar: :any,                 arm64_sonoma:  "77aebad4b3fc1c241a19f39999a9ba442f0abb214585fefa12f6ee6363d93343"
    sha256 cellar: :any,                 sonoma:        "81246d499e4fca970cd60d731ecb128d3e91775493b7fd4ec7e1e30bf3cf7132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbaf7bab6d7a5f61047a4c12eee0fecdc0e0ca5a127fb6032abc0fd29ba69598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a166147a8ef1f4dd7f064332d34d3c140729da8c8e6d049a02aff6f15173aa2b"
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
