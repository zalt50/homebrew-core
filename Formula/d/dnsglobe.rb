class Dnsglobe < Formula
  desc "Global DNS propagation checker TUI"
  homepage "https://github.com/514-labs/dnsglobe"
  url "https://github.com/514-labs/dnsglobe/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7e63f170acc2af62923de0c368b3c7d95ef9851b81f5b53c82bd529595def523"
  license "MIT"
  head "https://github.com/514-labs/dnsglobe.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsglobe --version")

    output = shell_output("#{bin}/dnsglobe --once brew.sh")
    assert_match(%r{propagation \(\d+/\d+ responding\)}, output)
  end
end
