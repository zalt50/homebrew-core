class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.92.2",
      revision: "95a957cdd7b5c054289345c04ac271128c84c622"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "913608fe5e429c126f45cd6fa58c4a6bf204ae463fe3e28324fb429fdb1c6270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022950fc92897e9a0de359a55a41ddc2e70eba597217f4f12816db01c9553044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "730553c01867db148670f73297a9c964676c1b226f281ba74aeb0feff99ce828"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf76e37650ec99c1999fd14fe759a45f34f3d76956a4041a0d1302dcf1fa5502"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691ba14afa80e32e94461389b035de9f18343aa87db8ccb150527c4b16f83989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6caa24ad27b3223b44563215a7eed2c2dd35e60c21ef7e20b67578c50a0f17"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
