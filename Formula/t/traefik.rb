class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.0/traefik-v3.6.0.src.tar.gz"
  sha256 "a9c2c3a0668bcd44cab4141e95601d1f069fbbe1e8e167f97ff2cefb0da6c36c"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60710e6e7400f55e57137e56d091a92414f4bfcd17ebb5fe11b058b14ba074a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d5b7ebd8efa49bc281cfc6acd42e1da60ba4748927b61198240008e34d6be35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "326c730f645f64f65b6168d7c85b00a93bd08bd8b4a309e87038da6fcd3733fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e230ca13617ae248b603c014faaf230e51d1ae425ff0285d43463c20e5bb73bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "877a0aaf0c89134d9d68ebf9b5d8caeef29f3be4ccc933263ff95ecb6040a9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3c5ebe6d92f21d14cdcc53a4995aa20faf241e226305ca645f06f4dad62682"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik Proxy</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
