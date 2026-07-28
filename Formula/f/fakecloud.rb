class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.8.tar.gz"
  sha256 "70a6c0e1c22441c2eab253690aa3f07a6fef627547f1a60422faeda2d6ce8f83"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f79888cc55183cc6f23c3c17bf98ead87acfccf590035cd8dba166c87a69a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ae740913017cb3732f52eb0fe99b126ad6b8beed43b75902b80f661b4c1b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13dfca5e3f869cda560ab93dc097a732ed13be135aa2fff706fa62c7d1578290"
    sha256 cellar: :any_skip_relocation, sonoma:        "1665e4193f27fefdad9bab04a8723a7838b9e6741468128da51440a61a9183f9"
    sha256 cellar: :any,                 arm64_linux:   "c5e2fa8114c3bbcb9161ef55ac3b55b9e20818156126c86b19bc91f6114000ec"
    sha256 cellar: :any,                 x86_64_linux:  "64e80bd17200ef1b308ced1fd14b1f7a7c55b29708ef086a1b1884eff252732c"
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
