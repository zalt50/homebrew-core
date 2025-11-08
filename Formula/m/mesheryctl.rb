class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.155",
      revision: "19995feae1df4c169beaeca02afee9c57e8bc58d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1c44d24cbc6f0d39f1b93c76fa0e638eedb238ae64b9a2e0c6a0845e3f088ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c44d24cbc6f0d39f1b93c76fa0e638eedb238ae64b9a2e0c6a0845e3f088ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c44d24cbc6f0d39f1b93c76fa0e638eedb238ae64b9a2e0c6a0845e3f088ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9929f37ef77dd6ff4d6449c638df44eaa1d4d38788bdae3d4b6d0cca9d12bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7d40f8bc3a16cc24480311822cb8dc176bbff1b65e9713234af0beb98c6a540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67f51d7de686de60189468a38cbf9de79c68990d9d5d99a9c11277bd67a2910c"
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
