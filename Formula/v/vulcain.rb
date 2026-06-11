class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "fa93f5d9352528ab708ffa5ec472841715622775ed66566e6a4acffe37bda3a1"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/caddyserver/caddy/v2.CustomVersion=Vulcain.rocks.#{version}"

    cd "caddy" do
      system "go", "build", *std_go_args(ldflags:, tags: "nobadger,nomysql,nopgx"), "./vulcain"
    end
  end

  service do
    run [opt_bin/"vulcain", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/vulcain.log"
    log_path var/"log/vulcain.log"
    environment_variables(
      XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib",
      HOME:          "#{HOMEBREW_PREFIX}/var/lib",
    )
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/vulcain version")

    (testpath/"Caddyfile").write <<~EOS
      http://127.0.0.1:#{port} {
        respond "Vulcain API"
      }
    EOS

    pid = spawn bin/"vulcain", "run", "--config", testpath/"Caddyfile"

    sleep 2

    assert_match "Vulcain API", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
