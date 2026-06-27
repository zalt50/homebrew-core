class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "5eae6ec77aa1ef6baaf29605e516d55f58215e1be51da55e9b53ee04753a6b0a"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dde01a64f52663fb061b5c8e9509bed31d642e9ab87b3c375fe4b458eb73655c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a27b7ed888728b8929a8100ae213fd989473a5cac9a9a0322270e70441b785c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e26969ee74f726a9361d4a1c642ce936d69840e57b81d2ca8ce61a9396c6de59"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b816cf56e2152cb14d9f47180a665b53c138c42b2a8ca289ea36a7a743c29b"
    sha256 cellar: :any,                 arm64_linux:   "e1f22e245f43816a769b36ea3e75e80e7cc93d16993dc7107e8ed038b830af04"
    sha256 cellar: :any,                 x86_64_linux:  "19eb1035ac4cc22ae65fe87366c1513402f025ebf50f2b8a05c65e918d3871b6"
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
