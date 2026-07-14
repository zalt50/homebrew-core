class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "dbec8379d7fd17c6109dd16f6e63bb6cdf3721bca04caafa258c5f690571bae8"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ed525e8993c453ec3cf69623ccc18375067309cccf794d502fc965899df2638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638d4dc2bd126adfe3451dded1657f5c32da7490a43051b56845a94f49412f5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "093e0b7738dc1134676aa83abb23b2fa6a92b3febb4e73e926e2a1ac97c1b4b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd75b3363c15f0ecc62b768b2a181a5b30fd46676a0ad43cd33dab7660e35717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd278697144dbace69d0a2a3b047921ec028ac9621cc16d80d8b5d74451ec60"
    sha256 cellar: :any,                 x86_64_linux:  "1c60c3fd67132028a5e4a9b1d09f501f40ef688d896c96c89c24b18c7b947ba6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
