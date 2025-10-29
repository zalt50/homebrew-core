class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.145",
      revision: "bf6a3eff2c393aec15cc7576d834c814ac3570f3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f54e5fd3b5ebb337c310d71f756dd30eea89ec51f51d2b3e6550502e141b163e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54e5fd3b5ebb337c310d71f756dd30eea89ec51f51d2b3e6550502e141b163e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54e5fd3b5ebb337c310d71f756dd30eea89ec51f51d2b3e6550502e141b163e"
    sha256 cellar: :any_skip_relocation, sonoma:        "483f842ca6fc280988a58793d7c33213a5cd8e18fc083dbfcd3b1eb186aa1574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61935042bf46d13f6a8e4cf51123819ce6058efa85eb92dde90790645509d91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c9fd18d68cc749cf3c99a3e25ad973fe4be54cb989cd551f714ef1da764d1a7"
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
