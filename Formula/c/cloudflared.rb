class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.8.0.tar.gz"
  sha256 "38e96c5cbe9421f0947109699b76ce6d3d97e58e26d2947ad33022089a362d00"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f185eb84fc39b91b2954c31240bbc6c1f41f71f8594453403ea5410d6b545053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "babdbc480013a4ad2cb9109113554f63bd212641256c3dbfb52836f08239d335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e168c6f104d3426c0ee5e9e8d4c15139f211cfc3a38f0d71dba41e23ad9925c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fcd7e03dd1880f1ed74087f5f879d7e9c5bd81670ae8e6bfdff2b01af08d4eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f29ab53cdbdb2359a4926fd9be1fecc062d40b1e357f7cfc222fc9cbdfe3c92"
    sha256 cellar: :any,                 x86_64_linux:  "d1848826c9aa95ccec3e3969387a61469139ddf2a838702e6f01b77a32f9157a"
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
