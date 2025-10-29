class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f2b2bde6cb70e6721f776214bfe23f36bd3f1ee3ca0ec1ece88cd15da7ac06dc"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc829ad2aa6af9d1a33c5436d3b22c1a8febef1b93a7795671708f42d8a65f73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "662ea29c83941d89358423dc2a688dba0921015a826ddc1e406c3020a5b38883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31a49f14f2903a934b7d9bab4dd302b67fbfac7a6e9fa3452ae9d3263da59ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "b803feceefdbbff2fe7eceeae63627377393ef00bef7e0ea9a5ea47b560cf7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d61f41f961c7c27e63bde526007225dda88b9d31eac637caec3cf8309e750392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5387ba27bdada69ac01c35a418c4dcd423638391e755f5ca08b838f45f9ec1ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
