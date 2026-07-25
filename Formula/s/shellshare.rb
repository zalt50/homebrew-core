class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "a5b2ff7d9b6c98e5642da320641fa45f8edb0777a1ace0d71b1d89109536ebbc"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ce1ee436ba2f4e2c6a76ae9daf86026d6240556703e9eef17eafb5bdfc56779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3093d37b09a825376d2ed10d625d513a805cde37d4dda953cf0c24dd3fe70e40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31673e5a4765088b9a4ca12c10f019fc487ef2ac2fd2904672c09a31a6c49e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "528d73e0ae69327c907f9d90b4dadc12320718e10d1fd716aed51d58ecf8c9e7"
    sha256 cellar: :any,                 arm64_linux:   "e21a74a223c647eae614b9ba98260227b0673d65b6e73da25f6554db312d0832"
    sha256 cellar: :any,                 x86_64_linux:  "1fb9036c091eff5f1736d37ab296ff915ce19dfa8c7841b70f0b3e4e55110e9c"
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
