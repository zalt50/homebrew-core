class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.146",
      revision: "ba418c7b21f396fd70d8fb6382d99cf2b32051c7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2debf08cf31e061f7fbbbdc82d077e0f33d35f7a6bff4d8ca8c854b9f53c1556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2debf08cf31e061f7fbbbdc82d077e0f33d35f7a6bff4d8ca8c854b9f53c1556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2debf08cf31e061f7fbbbdc82d077e0f33d35f7a6bff4d8ca8c854b9f53c1556"
    sha256 cellar: :any_skip_relocation, sonoma:        "aae45f90fdae41bd167acbeec722687d0f6b44a84d23941289e1c314e814ea76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d45d42e23873b8f0215bce4314e4408c6dec243093c2df8a086847bc0df394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "578112bc17276c10697104c1c4c94e8b57f1a704fef316a6e5ca7344bf2120ae"
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
