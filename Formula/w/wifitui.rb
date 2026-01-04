class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2e5e565eaad529b769dc2f558256c7a0aa51bdf4c1baea4353f9e533799395f8"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f54c1f2edf66688263bd5f2fee23994fca0a267f30b6fbc55896f471be774a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f54c1f2edf66688263bd5f2fee23994fca0a267f30b6fbc55896f471be774a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f54c1f2edf66688263bd5f2fee23994fca0a267f30b6fbc55896f471be774a"
    sha256 cellar: :any_skip_relocation, sonoma:        "94fecf2a277160d80e4445fc79aff80c2dce9d262f93ec1e02c2fcd1cbb9a956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8cd166cdc291614444f47ad480c9d64d7978475496c4906b302ff3dc608d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d07aa6fc725723927abb878f922d729caacb0a1a54ffc9153fb427e59e94071"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = if OS.mac?
      "no Wi-Fi interface found"
    else
      "error: dial unix /var/run/dbus/system_bus_socket: connect: no such file or directory"
    end

    assert_match expected, shell_output("#{bin}/wifitui show nonexistent_network_id 2>&1", 1)
  end
end
