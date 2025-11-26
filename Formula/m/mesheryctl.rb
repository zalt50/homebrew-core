class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.176",
      revision: "8e53f3df33a0e2963c7771798c4e561f7fd95f42"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dfeca4c10998dbcbc33054db3d96090f038b801803da67b54a74b4ff1387526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dfeca4c10998dbcbc33054db3d96090f038b801803da67b54a74b4ff1387526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dfeca4c10998dbcbc33054db3d96090f038b801803da67b54a74b4ff1387526"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c3a1415059ce9cf29d5de35868c4d3aaa13a56b10c6df79659de8d77e3c747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34a9e0cbc218d07078ad219ca98935791fc13c334d853c7c8e8627b01b01bd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32143158924c962cf6dbb6856732ae5ba02dfd5ac393074fcd7089f7362fd8cf"
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
