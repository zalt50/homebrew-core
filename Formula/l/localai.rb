class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "3fc2c53fcdb37bfed4ba66ce92638f4fd83af0745881e55af197eb813d5c70c4"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed7991324ce00d93ed49d566aeb527c9891c9c3b2dc3535524894d0a14c64c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f7774b1af07b8d3be6e62ae70838b7ede43088653907b096502293b1f6c3e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97105be94594e391948faee2f6d320e1b38a6ae7bd431b16f3d36a040dabda87"
    sha256 cellar: :any_skip_relocation, sonoma:        "110f04d010342dcf8dc2e7b3a0fabc6d1c9b0eb6a37cc44676cfb96ec492791b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fbc08abdace849579090955b787042c14ade96211e4d1336c05e44915634312"
    sha256 cellar: :any,                 x86_64_linux:  "f5b1d664bc08584ae2ba72815fe99058712b91c2e7b5c5dd7eb0c2d11b45900d"
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
