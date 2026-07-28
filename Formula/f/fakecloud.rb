class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.7.tar.gz"
  sha256 "6593b1f13e53917f2ecd2222a31d0797615a295e5a4c9a4f70959c44f29f6723"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "887a0040346799e532d6c8f29bf066ec7394804e347c7f09d4a25baf267203a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29502ef35794920c208670cf71c308bf7dba685d7c4b1b55f0ac69e4993bbce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e7d83baeda656dea891957ae249583c5fd423920ad7abab6050d4b70733570"
    sha256 cellar: :any_skip_relocation, sonoma:        "5245dfbfddd35c5f8f54d1f8d22462b7b0fe789d4b6f61ec2c3fc1d07dcc1dd3"
    sha256 cellar: :any,                 arm64_linux:   "f2a2d57838211ce5abe5f4447227fc2d150328afbad7a585aa3cbf7768885878"
    sha256 cellar: :any,                 x86_64_linux:  "4b804c27914550ad80f52e643d6ae9b89fdb95537dea3287e1b114d90c93736e"
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
