class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "8fc335feffa9db88ba41e444d7a52feba28a1853692fd9499d0fe888c435c227"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66842ce7b2896325a59bec541f3a3b2e9ffb8c8bbbe187eb9aa83eb2ee055ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66842ce7b2896325a59bec541f3a3b2e9ffb8c8bbbe187eb9aa83eb2ee055ff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66842ce7b2896325a59bec541f3a3b2e9ffb8c8bbbe187eb9aa83eb2ee055ff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e6ef8843cb826c5ab47155c5a1e3e5e78fbc1b7ebb8f0706f90f2219f6daae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405b55a23a32cffaa91b65fd0b34480e3aa67a4382eadcf13d1ac4674d9a4094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c554e278ea92395bb3ff2b7fa58be8e4e7f45da52ccdad173e629cc2a6623892"
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
