class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.24",
      revision: "aa99ad5d9a33bb28adb975531f594153100bc4d2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9313d4207db1c33b6df99cc4e9dfe0b4d906b854b52b3d6d35bec98a25d07947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecbb07c2aeb8cf43426bf28bf9f943223d68aa86b8ea69a372ed91b04afd0101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608f2cfeacc0f7ee30cfe89160277f3c36c45ee3f2e5b876e3f7368968b61c2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4a20fe3ed36d4d4819a4911be1e63406d114a973159c1ffc0aa626d0580245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca2bb6105621c0c75e92556e9b39c58a220c955a14e846bac55b5e7e3c478e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8caa66bc7d17a4b8ba01d11089e3fec1bcb3b83a3207109495820fdcbb5318a"
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
