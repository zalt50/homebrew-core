class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "b3aa032d3608fc18fa418bbb58188b2dbf76cbfc09ee80917135567fcb455568"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52459e1bd3e11fcd5fad79ce39946542bb6d0124197cac51830bacffbf2366bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81832a2e1d61e3bc1051035add84bea6faa9afc4a636b0c80e11dfb7c74b8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936e739bb3c535c6411f71b6d33ff914fb7f73c11590393b0efbd600b688e9dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1dd39f436619c5c3c6dfe035d11e1e80d695a962b849df10152cd7a676c22c6"
    sha256 cellar: :any,                 arm64_linux:   "ba1460fbc16ab8e799ed200c1c18fee8cf544a23881d93bf81c16f9a07a4d590"
    sha256 cellar: :any,                 x86_64_linux:  "a5b2f2e6b65c6b22abfd920cc442b8489fcb1e1ea7b820ca34ebf87c4115ab1a"
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
