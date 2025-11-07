class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.11.1.tar.gz"
  sha256 "1a52c1d09e844f947736bb4215c9cdb411954f53c5c31aa420a2435dbe336714"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3719da6d69e88246eec8598c107646dcbb79948fb1f0b34ee3bb1269178a234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d1839571744bf611e10f5f1f2a64231de088c2d951ccd723497252af972a445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433274a55b690b5ecaa26a6ac37eefd3bb08952a7aeb1c5a88b29fbd2c9172d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26dd62f8eae8dde6cfa1d9503ae85c20d2d7a0a3edcccfd5a5e8a5d750852a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682f7eb7d3f953e8892cf740dff6520d0bc2388f21084c1646866b4185685f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52ad1954b7b88c0a7e728b714a283321b1b0a49710d399463458d0161781fa2"
  end

  depends_on "go" => :build

  def install
    # We avoid using the `Makefile` to ensure usage of our own `go` toolchain.
    # Set `gobuildid` to create an LC_UUID load command.
    # This is needed to grant user permissions for local network access.
    ldflags = %W[
      -B gobuildid
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
      -X github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cloudflared"
    inreplace "cloudflared_man_template" do |s|
      s.gsub! "${DATE}", time.iso8601
      s.gsub! "${VERSION}", version.to_s
    end
    man1.install "cloudflared_man_template" => "cloudflared.1"
  end

  service do
    run [opt_bin/"cloudflared"]
    keep_alive successful_exit: false
    log_path var/"log/cloudflared.log"
    error_log_path var/"log/cloudflared.log"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")

    return unless OS.mac?

    refute_empty shell_output("dwarfdump --uuid #{bin}/cloudflared").chomp
  end
end
