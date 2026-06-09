class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "7e9ed83b0d1565fb42a42f03163739eaec6fa2e07f69030b2e44f8c4e54275ad"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ccfa9d3b8301b1a1383958024de604cfbf6f411e089a7d8742c2a42f75cf753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b118e15f705f781c7945aff54cea60dbf3443ea0aa0af395d3da785b3517a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c6cdcb9c848a32aed0549e1a71b34fa4045d0f580787ead70070e29e3b8717"
    sha256 cellar: :any_skip_relocation, sonoma:        "345e64dd90334c9210db4d4056cfc1f3db5ec46a1b1b1539609ac8888c8b7ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02062bbc242329d439fca8024d16cd7eef6329ad7dee76e44ac0a91295caad0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2f5c46a04ef158f15c83a14616e2d91ca89f84b43b277f3969b56c2c1cb226"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudflare-speed-cli --version")

    output = shell_output("#{bin}/cloudflare-speed-cli --json --skip-diagnostics " \
                          "--auto-save false --download-duration 1s --upload-duration 1s")
    assert_equal "https://speed.cloudflare.com", JSON.parse(output)["base_url"]
  end
end
