class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "6ccce7a32746e2ed19f197526107e3096bf20b1b8589cef26435461d30afb739"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubReleases` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3aaa3f710e73fbd0feada78f58d2d46b5926a17ac4cf2608f86566de90d60f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ab8e5cf539118273985bea863f523567895110ddabf225e35f4d5bd3d321e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c77c555df3cca776dbdae5d19335f293b0dce5b53ecdf0e2703f7f76fd96d81"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab0980a68a7298720a8f0643436ffdd21684072da2509853d14e917f02307bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "defbeb00c6993422e0fa2e4ea0c160a2535fbda73e1fe0e38ef3594b3ad71dc1"
    sha256 cellar: :any,                 x86_64_linux:  "f80386c7f1337c0a56bc4dcb92e7b3d7128ddc9a547d6f730c1c4952e9f7510c"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    ldflags = "--X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", output

    output = shell_output("#{bin}/glooctl version -o table 2>&1")
    assert_match "Client version: #{version}", output
    assert_match "Server: version undefined", output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", output
  end
end
