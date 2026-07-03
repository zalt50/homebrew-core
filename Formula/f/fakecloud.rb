class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e6f521e54d223b3b58ed235bce4c2a330731972faeb103461af41acd6a68119a"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc78fc5cacdb8d5f3508fcbb61c88bf7acb66bfc57b5213fdb0414a20a1f786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "496f1616fc851086a8df7a0fd54e2669b1984a6ffefc0438d22a5227852e5585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0204bf8eb2ae37ee36f18332ff36af572fd2b913cf0d58b066665af7fc29be8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c432a899d1eda622f1f60541c59899bdcf323bed8c15bab892c8d835ddf4bb1"
    sha256 cellar: :any,                 arm64_linux:   "95059420d2e01289a490ea420644bcc5dbe929e9ea7ee61bbe4ec6e2b93d6e0a"
    sha256 cellar: :any,                 x86_64_linux:  "e5e5e3df784cd8f26d1ec34b412bb8b6ae65fde06e40618ef791ded327e018fa"
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
