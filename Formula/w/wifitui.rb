class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4d2d8ea402c61837d94145c10dc5d64366dbfbc862747d49f993bb41803c3711"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

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
