class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "0bc4d67db238b974bb2a80b4786beb8ff3c38b748b3e10448c5f0174c7ead488"
  license "Apache-2.0"
  head "https://github.com/gruntwork-io/kubergrunt.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7772510be2278ffacfbea622090e6d1b7ff314a094bf9d6a58bd70eb794031b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7772510be2278ffacfbea622090e6d1b7ff314a094bf9d6a58bd70eb794031b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7772510be2278ffacfbea622090e6d1b7ff314a094bf9d6a58bd70eb794031b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a05fefdde6448280fe6b9a26d8c024f4d9b89ec398896a38540e8fef26af45f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "269a8a46002027f3c0b0a720262e4f7ce043fd0fa9397cbad870f5336224b0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd40b30f54acbc956b99e4cddb980ace15813d50856fa5074e42f60d4e0deb6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), "./cmd"
  end

  test do
    output = shell_output("#{bin}/kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:cluster/brew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}/kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end
