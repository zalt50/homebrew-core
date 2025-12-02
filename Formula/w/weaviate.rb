class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "84d19e82d890ac4e61b4b25026652809b07bd77e7af5ae23c7ef4300cb92b00c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d318cc8a4fa549b241f766db1464cc90853eed0759178866fa796bbefdd00ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d318cc8a4fa549b241f766db1464cc90853eed0759178866fa796bbefdd00ea6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d318cc8a4fa549b241f766db1464cc90853eed0759178866fa796bbefdd00ea6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd5df4a982e9cbc460234d2a729560b44548775e6ce6439d9427b5873a1a8b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d7a79d2e44990fb347a77fea61fb56fcd774cb6173d488a399c32a72630c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51ac90b6f0c15a4ac528779f408f31f6ab51a76af4a9c37a3f1498e5a0e76bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
