class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.175",
      revision: "8473659a4c6607838975ee3525c71ac94805bc86"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8263027dc1921a10b5867e3c42d3eb9f9c6b8d72b6d6a317c88f81a7a458db69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8263027dc1921a10b5867e3c42d3eb9f9c6b8d72b6d6a317c88f81a7a458db69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8263027dc1921a10b5867e3c42d3eb9f9c6b8d72b6d6a317c88f81a7a458db69"
    sha256 cellar: :any_skip_relocation, sonoma:        "49debb912ef8c8cb2cb3b2e1ebba704921f50cc707b39b849322ebd82c63e332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb8aee5bdbb339310ad99d31cf680914bed3fe4d083f6e6694a37decf4309f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d262a61d2ee3a9501f3546561d89b4b1bcc3ffed9eba022a660fbd1f1d3555"
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
