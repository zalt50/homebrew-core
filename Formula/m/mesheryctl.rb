class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.59",
      revision: "15b953b87a5fb5e0b56599d845417e38cbe86deb"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba41fa4dccf44951aeccf84ac541777c54244fafe1594cdd5ae9b81dda31f42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb5df95e14046272038e2c49a424ccb21dacd9a8cf636ecb86565b652ae8c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22baf2e1b63c21a102a613a295ce94a573a1fd4d84550f7056e94c75892e9af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e270e794d973461a81b49e9ccae6c4393e7a35e2defcc7c42bdaaea6f15f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761cb5cd0a2c8d78aed2c946a150217c02cff2bd0f4ae697744a827d2bb3012f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdf09a32bb16b6c5d0d93376fd342cfd68508cd3413701a9036d4986148f8bd8"
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
