class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5c214adfab626141c24b1a52d69102eface11ebd7493a497ad295c334196db48"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b8ea53f715ab7423a89b51e6881768db1901901afa5d7acac64b1f985c01c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f91cf897c0d314d5d0170071b155d7242170db4503b33ec33fef0ee7480c112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64eef9313e05b2e1db71eb0e1aec1890a7d4ad728a09b9107a229dfa281e3af"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d2453e9c2d81a90661fe4952b4b38d43b982d9068278b426bc970a9cafbe5eb"
    sha256 cellar: :any,                 arm64_linux:   "b34bf8bb7ecb6d350e81ae8f81b1f3f3f13dedf44c6ccb9b1e335a15932cab3d"
    sha256 cellar: :any,                 x86_64_linux:  "7ea4c31fbebb2c386e3c61023f1c50b6923404c82c0f279f006f64eab6582a08"
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
