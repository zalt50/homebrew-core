class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "2cdedbb227535cd10e9fc0b0db4a169684daf7d06bb832bcbaf4095ea682db32"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "023dd08c0ccbc1f4e119eaea87a4166665390f9e2ed2dc8dd5ce36caf4da4728"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a36ddc73cb049370aee8b99585255397e019b04379c3cf13a81b43a672fabb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "622a95535b45b4df2d6a884fa37ae0eb26cc13d6ac7ff7fdbb7f5035406f3268"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db8dbf4e19630ecf8ad0f96d16da17d8acbe36468f36ffc9c3a1d7bc8226177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfaea27c17faf2bccb53731dfe04079e2d205a035c38dd1c0930c40a89d5e2c5"
    sha256 cellar: :any,                 x86_64_linux:  "71acc52be4fb88481da07e3eb04a97b2619ea115eceec5fe04fed1b776bcbfcc"
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
