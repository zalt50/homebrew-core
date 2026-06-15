class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "f86696aa6e8f3fedd85f0f622339ab355b45ee7cc18b51b869da14e03a4be08a"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f571d254dedf4d6799547c6c7af078eab8a8fa32e83ca79850b4d5dae7b1a04d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee6331fbad401810dc8fed3db04c8ef0000c2892703cb01cb313293506c71af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a419514c47aee493b33118a020330f50fe610ebc4417841e5b679ab0019c1110"
    sha256 cellar: :any_skip_relocation, sonoma:        "96981f9a138cdd9d42cbefc0a685eb3fe5bb5d249c1ecc25f692489f97ae038a"
    sha256 cellar: :any,                 arm64_linux:   "80c19e85bcad5cd829d78fa00d5ef36a10c3366cad941b6e0dc7c9d4547b80c8"
    sha256 cellar: :any,                 x86_64_linux:  "fc3b9d7fd9a00614a017c4fd28db9054d5a73371839aa68ca841d27824b63a60"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port
    pid = spawn(bin/"shellshare", "server", "--port", port.to_s)
    sleep 2
    assert_match "shellshare", shell_output("curl --silent --max-time 5 http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
