class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with live telemetry and leak guarding"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "816a4b957c843f9eb9025124f0d4a400167c4fec6fcdd2d09855b5e674e1f244"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07557ffdc2ae01ac5d01fad143a42f315e129ee0052fd6ce53dfef482996abda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb64d8ba6bc74a15a6533dd7523c65a647962b9266a049551cc7d791917ee086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9425d2d9b254dadb4f09cf287b6f0219f1c1b2b0810843fc9133ff03e85998de"
    sha256 cellar: :any,                 arm64_linux:       "81169d52ba1d91db5bdde9eb8d8aaa68d84d83ed3f3af1dcfbb62e444cb35bac"
    sha256 cellar: :any,                 x86_64_linux:      "a09f68a3eb642432911c3bbdfb89f50e9ae90f693431e7020ff08163592b23c7"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vortix")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")
    # Mode names are checked before the root check, so this runs unprivileged.
    assert_match "off, block-on-drop, vpn-only", shell_output("#{bin}/vortix killswitch auto 2>&1", 1)
  end
end
