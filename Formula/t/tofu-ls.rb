class TofuLs < Formula
  desc "OpenTofu Language Server"
  homepage "https://opentofu.org"
  url "https://github.com/opentofu/tofu-ls/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "05f75c17c164c48c0b65a0d0f727dbd7cb921560c23a9bff3c4db4a2a847519c"
  license "MPL-2.0"
  head "https://github.com/opentofu/tofu-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d3e4c9469b7d123a08479b4e469d7cb86ba6fd749cbe1dbfc54f1aafeecc2b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d3e4c9469b7d123a08479b4e469d7cb86ba6fd749cbe1dbfc54f1aafeecc2b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3e4c9469b7d123a08479b4e469d7cb86ba6fd749cbe1dbfc54f1aafeecc2b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4a272b66e223f9e7ccbd8f85029671f491c4ffe5ff723ebfb25a14c8168c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0137f76821028e640f1a222c3eddd14d66ff97cbbe8b02599d56b4f4b065b8a8"
    sha256 cellar: :any,                 x86_64_linux:  "a67cce204d57752e8f0ccf840e9b146f3171172ba9f3ff916683cdf71ec1710a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.rawVersion=#{version}+#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"tofu-ls", "serve", "-port", port.to_s, File::NULL
    begin
      sleep 2
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
