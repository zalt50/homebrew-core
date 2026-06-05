class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.37",
      revision: "a1873ec962001bb704f22d9bc4d3457c72cd5bbd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00169e0b56170d50cf3209b298ebd23953612d3420daef376e190021c385570e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e03307b373e49b3de4f04da0faa9f348fa758840094f43adb8fffcb9cac5279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5961b72ee1e1b97dba04b995763fada27debbfad1acd0c2128091da3a0343201"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d5da47d7f85fe2e8b04d507a14f8638b686f5216aa3d28add0b0ad8e50892c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278b936704a41cedbf4a8ed4eea07f8373b32c13d40b3251f73fa36ae18ca93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0bd5058213f89dd89448691b1b80970b6a02f5a32369701e27248c3f9d94bb7"
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
