class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e6f521e54d223b3b58ed235bce4c2a330731972faeb103461af41acd6a68119a"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "333b3be21793f40db7d761cd5470dfd960ff3c23e992c733bcf171f10d4d11ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95762b974547b68bf7b62616ff643a9c180f7334f63f65c12fe8472b7b2bb887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcff1b58dbf52fc9ccf227d48133b0fbbe045cde82eafe7d45f5396dc975d211"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9c18ee103664738502599ef7dc083a6b9e66a4f1d8c746ce4f531dbd90bad04"
    sha256 cellar: :any,                 arm64_linux:   "1377e2cab3041be3a465176e56cb9bbdf6e67d2f37166e017e517e3f3a227008"
    sha256 cellar: :any,                 x86_64_linux:  "1db3bb2bb082770c2d3cc3c5af2ca7aee62c34c826befbdb5dadc04f5c355c0f"
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
