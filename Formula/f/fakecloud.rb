class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a54951b451c683fb2841e5bec3fd3e78f07250d98155139fd172b7be46dc7bc4"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73cbe5554976b6e908d709d7d505fe93c71de3c76b91e2179dc242215006fe75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8717a46b61fae21818bdf6aa8cf4b38270f01584a248385c328e47b46fc38fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d10a1e226ad0a7917ba623c6e3152024d60ec7b6ddd7f4d89f161ef099190eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ce3fa976a0ad7035ac77c32c2daa9908f523c67f1dff3fe6ce1befdb642acab"
    sha256 cellar: :any,                 arm64_linux:   "b82895b4232053c33451b2f307a69b0b5c1ef6b68adb0049c05f60651afcc58f"
    sha256 cellar: :any,                 x86_64_linux:  "7773512a07f38c8dd1c61ff4277bd0bb228915bdeb95f1541f78841ea702afc8"
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
