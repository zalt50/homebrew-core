class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "7a6aeed3c4ebb22476c3319ecb3d825d40fad73dd7166f35c898ea8e2fc28dbd"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32f5b03bcc31fce2369b3382d5384c01c9ee0f83bc029c1b1262b75862d71be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff82f9b773e8d3be02c15a223ddd3f53b962307fead83c10050e29e631df152a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74e4635c25ea34e507be9b4839b42fc9454969e80fa752985e23fc23a6790aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c97d035e0e4ed2623f76734a0442410b6d648ca54862c6171fd63498dee9367"
    sha256 cellar: :any,                 arm64_linux:   "da245a676aa85c9f437ccd9f02403827d1a62f159886720086bf1d078395ea03"
    sha256 cellar: :any,                 x86_64_linux:  "aea1d4211c51bdb92db95efbe1d4340fcd89e6bc2abb25975458c63713cf8865"
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
