class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.31",
      revision: "66e323022452cb2c80bee6ef17a019322c550b5e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de84a4702e06ed7264fec75dc1123408e196e30cb6fc0073557a63f9d0c602fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4a2363e79879fd3057722364f16f957f6a31cc574192378a4fe6dd475f60dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c40715a24cf52bf89bc309603c3ead2202f0ef3e1bed9938372ef05332e9e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "532aed90d8b06da84e1722122346295cdbd2142a5ef1c052dc00a2748c74eb7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7055354d19d629e9a0cec844bab9f808fd21d58485fcc4f0a509405f6430a104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a0a9f115f9e7bf6c6410067376d342ca3ddbb5ec0a58e6a2f4d9e1b17ad643"
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
