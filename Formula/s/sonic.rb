class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "ebeb7b7fb801a4b413c61898b5ac4f48dccf83d360b7878ea03b59977bfedb03"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed574ae9b9dba3214141abbb2e450e7e508fa614d5f6ee09f5905a919efa32dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac931473fd6bd7252b5bd8edaacba2669db9cfca52f48ad9d2ad2dfeedc48b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fb2809eac2fae71fdd646367be9c9d20e908a3313aa5f70218ce5260ef96f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "908ba9793d721ae4c7b9b4f1b1cab12e867397c8c4986cbb5a8d065c6d9c052a"
    sha256 cellar: :any,                 arm64_linux:   "134297e47144d340021413c7181ae398b2a064a81096e298554c5ba48819a836"
    sha256 cellar: :any,                 x86_64_linux:  "cbc7a47a7eaa1807648a0f5f3fb0439118f4303b98518c089426b2e7d7b39b74"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "server")
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin/"sonic", "-c", etc/"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var/"log/sonic.log"
    error_log_path var/"log/sonic.log"
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    pid = spawn bin/"sonic"
    sleep 10
    TCPSocket.open("localhost", port) do |sock|
      assert_match "CONNECTED", sock.gets
      sock.puts "START ingest SecretPassword"
      assert_match "STARTED ingest protocol(1)", sock.gets
      sock.puts 'PUSH messages user:0dcde3a6 conversation:71f3d63b "Hello world!"'
      assert_match "OK", sock.gets
      sock.puts "QUIT"
      assert_match "ENDED", sock.gets
    end
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
