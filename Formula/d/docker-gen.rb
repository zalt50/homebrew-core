class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.17.1.tar.gz"
  sha256 "3ffde47b1da536b8c2c4143449b0b01b3ba7bcc7da735bbc2dcb12385cbcc068"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d313e3162aa0bfa3afb27b7eec5ca37e6cdef6275e49725f9842fd3dfe2d8c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d313e3162aa0bfa3afb27b7eec5ca37e6cdef6275e49725f9842fd3dfe2d8c01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d313e3162aa0bfa3afb27b7eec5ca37e6cdef6275e49725f9842fd3dfe2d8c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d1ae987e48b6045047066a19a575e4e3037397510fedc5cd26f161f28ea47f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bafee36b5ff2ef1dd5ac091ab8599577bbb886a401bc770664e42c4edcbfb7e"
    sha256 cellar: :any,                 x86_64_linux:  "cdaf7efbd7b614b85df89f95c57b83d0498b2c660a394da1965f2574a5af18d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
