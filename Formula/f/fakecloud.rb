class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "d9510dc0c9c93e55e48a5470373331b849f6d154497b9334218d79be238c77e0"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f60213b23c9ca90c1a164201a66ff15302f1c3f78ee506d72a6110ecbcb163c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc7e151c4639b60c295f3fe0aef4efb6fd4780fdd4ebc76a121bed785e059aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1f1622d18324ecd92d61139e45d49cab105aa3f5c51469b3782f05a1c3893e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a653692730e80c7a04ea12a6d58d1b54e8ab9456499418b2fb2d320153f7e3f"
    sha256 cellar: :any,                 arm64_linux:   "c1376187d5e9372fe02e359461bdd5807d32211dfaba1c202c90950b73bfaf51"
    sha256 cellar: :any,                 x86_64_linux:  "559f6fb377ffa2f55d84fb570ff4610aecf39ddacdba4f72657f81116d865ca6"
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
