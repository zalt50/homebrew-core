class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "d21e19ec16193eaebdaeb8085bd23874ea599dbb3ac617bcd63004d50469e82b"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be461ccde88f2fce4b5827aaae2d3c86041b731cda94dad9945c3a9b648bf05c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb33852e2964f2784b28bc34eebaf7855f61f7a82d7280cda3101b54656a115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d68e8cfa17d05531da1747d3cd82fc9a4897c8e1fc0fbf2835b001f07bb4c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b000f367389336b9ff0a3f9f1aaafc0705f227ab45287a3c3f704d30cec31e"
    sha256 cellar: :any,                 arm64_linux:   "2032b6f7255c8de5236370388770038d0fb203b544b1ecf2e54f0e3d9216853b"
    sha256 cellar: :any,                 x86_64_linux:  "5ede9852de0ed9e8551704e19df66cf868976dbd8212f04a34d6e31e74d6f97d"
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
