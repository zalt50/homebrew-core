class Gwctl < Formula
  desc "CLI for managing and inspecting Gateway API resources in Kubernetes clusters"
  homepage "https://github.com/kubernetes-sigs/gwctl"
  url "https://github.com/kubernetes-sigs/gwctl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "07e300a95a9c2e8e88f96c8507e5acdc1e051f8b79125ee9c8174a06676ef655"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/gwctl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/gwctl/pkg/version.version=#{version}
      -X sigs.k8s.io/gwctl/pkg/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/gwctl/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gwctl", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gwctl version")

    output = shell_output("#{bin}/gwctl get gatewayclasses 2>&1", 1)
    assert_match "couldn't get current server API group list", output
  end
end
