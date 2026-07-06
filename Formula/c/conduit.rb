class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "55294ce18e3aa9ca140172cc8b83ce9c6c61d242e65d410725b18835f944b3d8"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "111565ce1113abcca6611280b4f23d6a06c046bbac62dbf93b6be9ec36eaff3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd141fc8aa37951e3a0020a07e9a42705badad793f4ff1db8bd78dea812b20cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b995f04f9c5d9c08a70fde55907fb767ff4e6a758fced1b0fa169e69f1fa54"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5642be694d2b8ebe80ec664b9e6f46314e950c35850d54304fc0c89767d728"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b7eb3bc131117a30bd3984f370edd43d0ddac15749dd97994e161e3865c957"
    sha256 cellar: :any,                 x86_64_linux:  "d34a6c97058aa6a491c118603ba8e0dd453a300873acb25a5d23c2da8bbc0e6b"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
