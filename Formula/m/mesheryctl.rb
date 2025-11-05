class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.151",
      revision: "18e1472b8fff0c9ab27c06468f78aba9f408898a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9bd16f0df17d729c8bc4a3e990594a582f9eb91a0eb81576c6743c80ea77e56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9bd16f0df17d729c8bc4a3e990594a582f9eb91a0eb81576c6743c80ea77e56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9bd16f0df17d729c8bc4a3e990594a582f9eb91a0eb81576c6743c80ea77e56"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1817ab863723d60cf9c4aa7a1d319b05b09255c4c69f016ceb0ba49d349e728"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4964787668128521d77d97967ef52edb929bf7f1419fcb5333ddd3521fe9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3920b979b9cfc883e066ac92ce95d19a342dee190205a27b7b77ee6e3983af"
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
