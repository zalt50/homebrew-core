class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.2.tar.gz"
  sha256 "3645df0e094fabe2bd22341158e39d20ab508a2b2c36a02d6cbd8ea214883e3f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f7102963e9f25b2fb5cc190b80c635e82cddca3d0c197515379f87592b7b5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7102963e9f25b2fb5cc190b80c635e82cddca3d0c197515379f87592b7b5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f7102963e9f25b2fb5cc190b80c635e82cddca3d0c197515379f87592b7b5f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "39cb25e2546c76b66dfd19f4258990ee9bb9ecdf16d9230dfaf06cf71a3bc8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8888abe3def23b18a8b1aae5fb79f3250dd6cf703f619a435814ce460278a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7524e6288871c62d020a37aea3ed4f715cc43504b3897e3707be4608f8d55ef"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
