class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://github.com/kubermatic/kubeone/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "8a436ffcb96b932053e3d115c574fd49076b2747bf74d885b90990ab4df0940d"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28d2f0248f792abe7c6cc5253f115e81f1597b2c0bbe285001eb987bb402aaa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26aaf6dcbfb6ce8a1df591a052a14d9a835c6ec07a684d311dcd31974373b697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "686976d467df70c20d537b8296145528b3f920ec06a294087e7536b7848fa8ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ba180e138f97618de0156cfd4dfe0404652da47a695a7ed652d6ab01b56a3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e2e9b2b7529bbf6d25d80d4810f6dbd9cd7baf1c18e91a0c4531028840c7657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3194a43bc35ebba3f7e68f5edbcc4195f7e4869695fbdc6bd875bada1db6941"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end
