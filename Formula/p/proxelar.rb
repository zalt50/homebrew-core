class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "98f65d79a1cd5104c1625ec0bab2edd37a07b6b5114173b1edf358a32970cc2a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2add9a3f7c7dab6f1bbee47f6f2161b1bde1755a41bc52f161dcfc67af05aff"
    sha256 cellar: :any,                 arm64_sequoia: "c90c8215f01ff93b5808bfd4bc84a6c22612b9fd7d0d4d9ceedf4d4ca84d3e1b"
    sha256 cellar: :any,                 arm64_sonoma:  "40aec9d28cebc01f699f70659e5741de5854406030880db4a4c99673f3276f9f"
    sha256 cellar: :any,                 sonoma:        "aad65a8dceceee3ab9f1d9a8a7c51a7f85fa50d3fab2e2eb04ef268a8c76d2d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634bae86968fd9f56d38cfc469052824639726b4d5c73a190300a976fdde5164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941644444490ec054ee2da4c119d1b43abf34de08529bbfe017f3a88363607e9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "proxelar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxelar --version")

    port = free_port
    pid = spawn bin/"proxelar", "--interface", "terminal", "--port", port.to_s, "--ca-dir", testpath
    sleep 2
    begin
      output = shell_output("curl --silent --max-time 5 --proxy http://127.0.0.1:#{port} http://example.com/")
      assert_match "Example Domain", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
