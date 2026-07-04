class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "c91f0c07035df9bb760c3aee2111b1e93a90e6b7571c610abf458e504d4bff96"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7412e28f4444083bd549cfc91d52e500eaffaf5484370d74168c67fd225cf35f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dac6fe4e0f96d54c6fc2f8fc3379c9006984c04cccb96d82f436a30425bd5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24c1d14168edd72ffa20ff0addd58abb42859e68f7a74fd9e8489f4505ac492c"
    sha256 cellar: :any_skip_relocation, sonoma:        "435b5f97f24b20544c108b92dbeac12b868af450f71d468bc0e5cb5005e7ee17"
    sha256 cellar: :any,                 arm64_linux:   "f2840dfb6304a7c1a0adfecc394a939b41a531a2af62cfb0acb0b2abc0edf676"
    sha256 cellar: :any,                 x86_64_linux:  "6cc7f638c84a340022cd8c470570341cb8ec4ca36b792e2fa46c3d0d5c6dacfe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
