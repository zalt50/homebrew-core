class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "1a4d4b8f77a2f4c51d901c04f3d86cbb2e0cf07b245c60bc95431c9d94056fc8"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad774c93f22334f87a44684615119e3b7b022dea7d4c8ab8719124267eb82bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107e4a95d64653fcb1620f829b160c6b8fb4bc354057d202a61fc43b1818f0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa06de54e1c6031ff1347761fbe4c517a6e77e07c637c3a34e21ad2c90033a76"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebce72de94396db07e5c5f3e845fcff8035bb1896801b28d93305894d8b65b60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b00b838927163b0300cc341488d4d7404dcdc0e927f9da822b69c4453e44ee8"
    sha256 cellar: :any,                 x86_64_linux:  "d6c46c53a7047ffa52b15d46ed6c36cb84ee99416a28b690ebafb1203f6ff0c1"
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
