class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.159",
      revision: "eb5165c994da30f992f5aa27a155c7a0ee676e5e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ba713adb83325295cac603bd874dc0770ee3bd64fff965d43d16d2ce10d48ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ba713adb83325295cac603bd874dc0770ee3bd64fff965d43d16d2ce10d48ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ba713adb83325295cac603bd874dc0770ee3bd64fff965d43d16d2ce10d48ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "7488f0f329696328c4d498facbc55f4ac0fbdaa3c3d8388af55a0eb538a9814c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1dc404ea68424df13c48bb2d9f48590b10cf9c61b46c3e323a68f0be7c24337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "020f68926ec600b35489aa88cbbc1043f162f38353d51506142ca130801c921a"
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
