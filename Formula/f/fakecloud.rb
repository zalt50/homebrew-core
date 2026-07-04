class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "684cf3941c2c66b79f7f290d021aba146307a35bf6b1e4b1242686d65667c030"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d857f81fb5773084b776c0be2e0109962591c51b8bc1df15487438025e66bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccfd3c21614a5554fe4498ed56a8c47efbd698bb2f20f9c4730c306ad3823083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a8b9a61ed044b3f0ea6ff5ac876416496b419f52820c21280e6d20050072682"
    sha256 cellar: :any_skip_relocation, sonoma:        "2333d5d8c549e9ea2aaab385735d66ec6d007f479f65c35fcc5c8ead0fa6342d"
    sha256 cellar: :any,                 arm64_linux:   "34a62613d0b149cf3d50c458c7329e523e71f1802fd4436bed3bd4efaba898d2"
    sha256 cellar: :any,                 x86_64_linux:  "f8e02b197ced47230a8a6884a82ce507e37c868248d94e497fb2bb6ffcb988be"
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
