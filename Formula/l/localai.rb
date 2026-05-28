class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.4.tar.gz"
  sha256 "ea9024dc0d04cc39d08d0552d0b8ed123408c576c823bfb85be2c2c3bf7f416a"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f3cb70c4b0f57713596fb9fa5eff091652b501997aa2b80635fa64716a93f36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "392fc9402d07c3a7d83d1657c933f46c6e3be0948606f61abbe09e39cee2427d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfb1362229df707d631e5ec780dfb28fa3e17d9afd9e4c34be0ee810fca13e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6c62374084f5d77eb1ce09b0362684db6596bf88ac8c38d2df437d2a43d6f0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807c9462b30fa1680a5ab38827d554e8188089a35af9ad2842f73a5e1e04dec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43917f671fed1047c4790b09a8c006cbadf1372ca24dcf5c2c9fa3ada2e83a3d"
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
