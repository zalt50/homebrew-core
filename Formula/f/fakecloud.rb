class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "a9fa91275884c9c6d5de3ab776ae24cb6e0c1bec6e333e55b942c167094ff768"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e92634512226917acd79139d569a1296e6fed2044ee6cbcf2d24bbff20ce649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bea88666afe95f45e56c89bb9bc5ee22adc5cef6c0801c02d0aad555c6789b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2daa8d5a3e39caa5288a45dfacd3f3a6ade06d79b0f6f5e9536aa2408e186acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a84c0b0aa3f6a1c4a5a3366781b495f4fa0a589b5e2e8319418674d4823e07a"
    sha256 cellar: :any,                 arm64_linux:   "73d1a9734a5dcbb4044abd82ce4881dda17110455f6e58c677668c5aaf297b47"
    sha256 cellar: :any,                 x86_64_linux:  "7f627142060a6a868a728cf026f98b3f2350c15c2dcb80952babf69b0ab96253"
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
