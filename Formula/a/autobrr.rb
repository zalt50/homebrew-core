class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "473ffb90c42b44081e3c063e31086f6f17b498cea2199a789c39fc295a594be3"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f66bd46516dfca9a0d40f0a2a4131f8d43393afd0e932f39fbd4f38e0b4a5de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d476ba2ba33b8c0ba9ce81f679e57f5d490c325eaa0bea927616533003af86a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f8aee1a560c8c0d1f2b1a6aafb4ca60c624ab0880e5144f818d985ff1b6640e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37c8f68226afe4ac32ef4930951cd6e4b32ab390f89a12a145c153471ea345df"
    sha256 cellar: :any,                 x86_64_linux:      "4b3e3abd7d35da0520b1fbcafa6231b0eb26aecf1524760156c7e0a6d12c5e51"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "web", "fetch"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "web", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: :goreleaser), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: :goreleaser), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
