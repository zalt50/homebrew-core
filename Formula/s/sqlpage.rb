class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "1550ef8ee187f2ddf16b182b51716606d7b3e6ba71a6c5007de0a61c94d71bec"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "504cbefb84b0953189d489da5f74aff9fba606e09ddbc79400a3adf802bcca83"
    sha256 cellar: :any,                 arm64_sequoia: "4e28d0d76f4d5765247cdc9f5996f9471f87678b301eada21e47eedc8330a410"
    sha256 cellar: :any,                 arm64_sonoma:  "4eeabfd69e1940408d44b5875eaa4e813c61faafc7364fb1f634b68510077344"
    sha256 cellar: :any,                 sonoma:        "c568135b35cafd9931d9238dab3eca10aa1c6ebb32d4401e7452e84e3660216c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00fbbc3f93f695d0ed947886b28f1f7539db72b834cd0fbb5e0e0e55094e2fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61281eea6ac79e79552bbebd7fcf9619d4a037ec2681b19b00a72935e9504cd"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    sleep 2
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
