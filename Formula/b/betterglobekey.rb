class Betterglobekey < Formula
  desc "Reworked Globe key for faster input source switching"
  homepage "https://github.com/Serpentiel/betterglobekey"
  url "https://github.com/Serpentiel/betterglobekey/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "c4241735569fdfc698427e6c764cab111a591c19022f893506d85e261b67d23a"
  license "MIT"
  head "https://github.com/Serpentiel/betterglobekey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6aac2739582f3787fe068e01dd7b01f3ed1d15191371c011bbf6ce089d5d76b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ec4d470351e26b94f5b40dd679386bebe4b4a3803125a1eac90f9c3c7b31f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc368174670be60a8cb0c1bcd89790106832a97f37a56c2c4881a802a75e4f0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "45dd809d958a950aa2e1205ea76359ff68b47dae3dd36136d3d1569bc3f5ef77"
    sha256 cellar: :any_skip_relocation, sonoma:            "5a38b512bc8138cf37502d6db7fa86adccf5d886d283682c5687ee546d2e3a26"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"betterglobekey", "completion")
  end

  service do
    run opt_bin/"betterglobekey"
    keep_alive true
    log_path var/"log/betterglobekey.log"
    error_log_path var/"log/betterglobekey.log"
  end

  test do
    list = shell_output("#{bin}/betterglobekey list")
    assert_match(/^com\.apple\.keylayout\./, list)
  end
end
