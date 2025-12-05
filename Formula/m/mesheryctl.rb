class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.178",
      revision: "b46185f10c57d7d443e9dd1319a20647348c4900"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d864d34e98e4d852b46fca69253e5d55b28a1007758e51316d92a0d2078e81f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d864d34e98e4d852b46fca69253e5d55b28a1007758e51316d92a0d2078e81f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d864d34e98e4d852b46fca69253e5d55b28a1007758e51316d92a0d2078e81f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "30be0d5a78c1eec9567083748edb4911124f37d04de81ecbe4b0c94301e68e81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "973395511b2494c9aa66f66b2a2864cc915f07e81e673b36ab425f28bdb58646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13bda981f6a3acc0338d448d99a10920fc1092554af17f45ea1ed5f41d429f0d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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
