class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "f16654c75c27bac91e9709881ceb37b0b6ed840ec44314f40c360f774f83a67d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea0dbd0e70a200e796eefd40d5f47c8b4452931a1bd5f64410e800d0b67eee61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0dbd0e70a200e796eefd40d5f47c8b4452931a1bd5f64410e800d0b67eee61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea0dbd0e70a200e796eefd40d5f47c8b4452931a1bd5f64410e800d0b67eee61"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ba0c955b5d9b55caa2c61bc1e95fafcf1f5ea49dd968b09b9338c680286979e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d1054c718e0f9758b1bc57064944cbab51200900d03f5d77a6d242248aef6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9cbca60d8a90737e954822d662d016ebd9b7106d8bcde95ed42a9c26d0d58e"
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
