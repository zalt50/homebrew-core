class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.140",
      revision: "2568a152d0a6d0e601154382b448da6c13db8f97"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbba602a8f412efc45e10323915b70540c1c2b965c312cc31af0e65713a511ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbba602a8f412efc45e10323915b70540c1c2b965c312cc31af0e65713a511ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbba602a8f412efc45e10323915b70540c1c2b965c312cc31af0e65713a511ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a933f6514e517a1c71c23a875c1429216d5df18d8427d32b37c2ba48a94e10e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb65a7ed8690f213b162628982d6caa00d267d63487ed81efbd075e257579cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb888b0a217b8138bc23c3ebd39507ad40aec243ac89b82b4866b197d88a9c1"
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
