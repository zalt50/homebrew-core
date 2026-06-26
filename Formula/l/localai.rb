class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "b48e0fcf099ba439ba443e58a2308fefa0e25ea852df7e3210e882c1cb16c603"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48243243f4ac22f5c35000931e1cb2ba58ee602991fbd7e7f85bd0d6c5f6f878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220dbbd59d1bc4fb56c81ae9f72c01cc65d4a3e75b42196d1222717aff970eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eb95dc99c7fbbe5282624d56d72100103b80a505be66faefd14d6144a23455c"
    sha256 cellar: :any_skip_relocation, sonoma:        "59e874d222ecd0cc453ad06ac1373ea54c9e54a2c71641ebd03b6562b2123ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa7838c1f7ad70399ac91f91068c1c12b3d429722895328b46d301a4b4b379f"
    sha256 cellar: :any,                 x86_64_linux:  "d5ec2c74b472312a80fde9242960d44a74b620ffd9179b11dbb251782217c148"
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
