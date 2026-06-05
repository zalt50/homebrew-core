class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.36",
      revision: "877dc75c58d114903168f48188b80965d3c14f5c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b5b7cb7739550da985e7f566b90f1554797dc3954ee50c773b28cd2a1daf3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dc1fb96a3d2b6c0d26cb8bdbd4d80e7f9187949a847530b04da48bff095a935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbd6ae75ce4d16ff46f25c95822892e3a532857f6fb49f14756390b63055b653"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a86f263054281864655435cabc196821715aac77a3f9cee1b0bd472db01603d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10785e320589d7e03c1cbbe9ec22fc6be9ebc8f9a747875bbd12f8fd4f1a7049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa93762e47aac6a4e09081aa842eef6a9b90faa05326a7b14e12505ab246336"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
