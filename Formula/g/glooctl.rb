class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://github.com/solo-io/gloo/archive/refs/tags/v1.21.8.tar.gz"
  sha256 "bbed7b60ffc5a2c28a2fc8138243e3a7c31ddd17b84571295fbce33acb2081f9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebda72747ac865884ca1ed354adca7a35003c2cbe48d33916230f73f73c2c064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4095d19ae2e36d780a13cce48adaf61937f4dd15dae406c8c034f18b1da7cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7964f87ad9f6ed4e87c22d53be6bc43ecfc380df092f7d25b6d83fe15d946a74"
    sha256 cellar: :any_skip_relocation, sonoma:        "0565bcc0d91d32529b1a400c345a477e85a68e02d15a862a0a6ac4d6418a2b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b249c0be83692330b557b67e6ec4f5e79b7c59a01f58f2d2ae14aee7bcefd05"
    sha256 cellar: :any,                 x86_64_linux:  "a07b63a64a5b7706e01218abf67ab2f12393127b5df7394083920b064a5260f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
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
