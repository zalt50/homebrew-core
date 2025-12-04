class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "9e45ed5cb97cd6c7bcc0dc515679ab4211240024ae61ba011d76414fd0ca0b6d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5853e76d1dae2d7dec69439fe6f3cc2a8fcd6b4c7c462e97d6eb9071e8a68326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5853e76d1dae2d7dec69439fe6f3cc2a8fcd6b4c7c462e97d6eb9071e8a68326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5853e76d1dae2d7dec69439fe6f3cc2a8fcd6b4c7c462e97d6eb9071e8a68326"
    sha256 cellar: :any_skip_relocation, sonoma:        "416d46180f7726074a57789f797ca8b0493610129ca078dd648205c9e28f9ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174d9a4e94c7feb05b63c16417a6157cfafa4f97dfb8c311810aa8f510bf70aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac37734d4973564f17b4de0576a5772a07b497dc69161024294dea90cf8c9098"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    pid = fork do
      exec bin/"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
