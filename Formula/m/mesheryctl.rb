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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f499a4df693a67b4ce5a4de745047c4982b8bb604f128e020da81c6ff50f1585"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f499a4df693a67b4ce5a4de745047c4982b8bb604f128e020da81c6ff50f1585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f499a4df693a67b4ce5a4de745047c4982b8bb604f128e020da81c6ff50f1585"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f6d7e15a1be063ba1cf7904935ab84f3018d1956c3bee9090c2a30cf7c53fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "935ac6aeae128199e3248265378da8792fc7358ca2a54570ce681e52e6858a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d9b413d717564d1651c7b30df1b69702aa6ee750abb7f2c5cd0c3623f7532a"
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
