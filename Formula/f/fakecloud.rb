class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "5eae6ec77aa1ef6baaf29605e516d55f58215e1be51da55e9b53ee04753a6b0a"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbc58173131a27c972bd3bb791c41960aa00a02ffaab154964ab554924da5bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "530181dc6f7a35e477a7dd9c2d7af1b827ec8387b0855482f449bbd0f3662c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "454cac79f85a4beff0bd2b9d6b5d4a8120b1e351a19536a709d9454f0e17009b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b677c388daa54db60f3f46b60d799a017035a3d49e1ad92809ac2a6b668feb1"
    sha256 cellar: :any,                 arm64_linux:   "60fe6d9b158d074bee96ce8f38ddd105a6c982181ebb7c71c1aceb67b619293f"
    sha256 cellar: :any,                 x86_64_linux:  "d7063557fec4c1b849672526f0917593ec93f8003f2936233eff0c3162674413"
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
