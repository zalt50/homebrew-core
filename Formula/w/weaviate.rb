class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "5293b72f7cb1a3dba0e30ac1863f4c4ab7234472f46ee3abfa8af0e78e9e3c9a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e45955d63b91e8a0f32c89287889abeb6e39568dd385269bbb89fca2cc64608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e45955d63b91e8a0f32c89287889abeb6e39568dd385269bbb89fca2cc64608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e45955d63b91e8a0f32c89287889abeb6e39568dd385269bbb89fca2cc64608"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f17a21c15da4326eb8eab93808094e0971cf0e4229bf91302fb715b22786d9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4fe8b044d7d26a9f4301a1085ccfc7cd4d38c24e93bf93966b3d434184d3c64"
    sha256 cellar: :any,                 x86_64_linux:  "55f1cb7f60af478f00c5a9a6b3719d315f038889caef687fd6b0f5e0f6943af4"
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
