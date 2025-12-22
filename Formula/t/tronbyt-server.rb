class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "785867e7e84b62497df4346e9ec7f402bc495532a4df7624b5aa199ec337935d"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48938336a34ed0b9ccc82908571fd8a873b17fba3e90bb5675b88f3f53307765"
    sha256 cellar: :any,                 arm64_sequoia: "09b08428f4ee0e8e9a086ef1ff147112e54cf9e740cc76ff666fe95c0c665bfe"
    sha256 cellar: :any,                 arm64_sonoma:  "fcacc319d12d30194659f034e4105c1352e0aa8eee522c7e372c1d5707b2e82e"
    sha256 cellar: :any,                 sonoma:        "b6ef4f3f4dbb063feaaff70c75458c2a87bb30f35b4b53f7b406930eaed5d2e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10c66d569f905d34706d8c21586f410e271c2f51caf4802cafaa1b4c4234ace1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efecebe06bb06d7f92ac5c0a2b963c75fdc28232e32a5ee4d06569f50fc5b0b"
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
