class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "4e5f55e2945c7e25f0802597ef18eb0e3e9d6ec89489a2773461f6fb291f7305"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c91c8b1583e03c4fd168cf1c9f583c20919d618680d135deb208be5ca0aa4a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c91c8b1583e03c4fd168cf1c9f583c20919d618680d135deb208be5ca0aa4a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c91c8b1583e03c4fd168cf1c9f583c20919d618680d135deb208be5ca0aa4a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7c81999365d2a9adad0be8d91d4526fae18afd89f982b673885b8900f012bdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "676f2de7f57ab5b630cb812522d611831c26e7cdf44bfce8684e1f3f6a5cabe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4aec17dab50b5e49c7a1a5d556d021bd38eb5a79674b725ce56d10290aa59c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -s -w
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end
