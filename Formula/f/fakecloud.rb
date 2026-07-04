class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "c91f0c07035df9bb760c3aee2111b1e93a90e6b7571c610abf458e504d4bff96"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b29bb9285298a9207f20fcde9483d904cfd2d960048e0cf48d23ef7753da7b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7709ab9eed8211664ed4ac0b10a62b7d68f733bf8566da6838d166c779d308c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da4884bc211a3f4311a6df944f81e6a704fd676badf1bf4fb6b3a86d801d671e"
    sha256 cellar: :any_skip_relocation, sonoma:        "56030407c7bdb5dbd40753d2392451fff8fa217e0ce8f77ab0de26ce2441c284"
    sha256 cellar: :any,                 arm64_linux:   "90d7dbdb3cae56b6130d026933966e0fee75fa0f40e8a7c7ff2d0edb3061fdb8"
    sha256 cellar: :any,                 x86_64_linux:  "3aafbbc74555366183e920974baac3f3939b327ee78206c72c0530afe8aa1fdb"
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
