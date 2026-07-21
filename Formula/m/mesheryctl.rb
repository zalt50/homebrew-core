class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.61",
      revision: "f993364ab34354ebe7e80c60384bf151b2fb9cbf"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6fe91cfe3ce0a5c49d12c6f481230fcc7a1e3afe48b8dd3b29c282f433e31a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a5cf42a2853ab86132eab6e47ed6dcdaa6bfa6e2144e55c6033d344393dfea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27d81bc0c95e091fab29455abdcb1581264bb590910c7d3e51a0816b328167f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b371735e35962b17d46bb565339f4e43def25bac9b625ca8a4239aa36979b9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767e892bdda72c52d7c9d6090010891d0e7aa9d61cd40f790360e34a104341c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42510169b7dffeb2d4a933d4f26f682f48bb90b1239f723781d37c91da7f4fe2"
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
