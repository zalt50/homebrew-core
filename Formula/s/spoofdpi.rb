class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://github.com/xvzc/SpoofDPI"
  url "https://github.com/xvzc/SpoofDPI/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "35b3bbcff2986636055aad4834e09d8fa55c7d306780ab8647969e2ec87a4349"
  license "Apache-2.0"
  head "https://github.com/xvzc/SpoofDPI.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e1b156bdad9850e43b438b5ca0c87e0589b931224717e0a836a5ce5170729b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43882aad50becaeabe8fa49cdb8d758d99b2217bc3b5eb4fcff04c35279cdbdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908d20f5df91c7092d8923ef72ba88b7e9b4a2e674615152afbba773ab71556a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3864893371a61523e9f4c0cfe9608725087af503dff1cc90cf99738005872862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bdb60291cb0bb8e52fa0e334ec385f84cfb72aa5c4996feeb02d8c95d22dea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa35262b1da125ba26060aa67d116e2295bc14959a127c61b32dc95763bf417a"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spoofdpi"
  end

  service do
    run opt_bin/"spoofdpi"
    keep_alive successful_exit: false
    log_path var/"log/spoofdpi/output.log"
    error_log_path var/"log/spoofdpi/error.log"
  end

  test do
    port = free_port
    pid = spawn bin/"spoofdpi", "-system-proxy=false", "-listen-port", port.to_s
    begin
      sleep 3
      # "nothing" is an invalid option, but curl will process it
      # only after it succeeds at establishing a connection,
      # then it will close it, due to the option, and return exit code 49.
      shell_output("curl -s --connect-timeout 1 --telnet-option nothing 'telnet://127.0.0.1:#{port}'", 49)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
