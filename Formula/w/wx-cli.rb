class WxCli < Formula
  desc "WeChat 4.x local data CLI with daemon architecture"
  homepage "https://github.com/jackwener/wx-cli"
  url "https://github.com/jackwener/wx-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "de8ed8208d8b0af7c2fb93414f35f9816cbafdf654cb969f93bd374a87c8fe35"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wx --version")
    assert_match "wx-daemon", shell_output("#{bin}/wx daemon status")
  end
end
