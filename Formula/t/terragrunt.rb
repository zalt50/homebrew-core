class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.95.1.tar.gz"
  sha256 "e03bf2e1b6114d7d5c0e0951c5d3d8fdec6c466a1fca23c5b82aba6031c0662d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34a05195ea5522bd9cff520a1797a8ccce715aea83c2ebcd9338209a75d0107f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a05195ea5522bd9cff520a1797a8ccce715aea83c2ebcd9338209a75d0107f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34a05195ea5522bd9cff520a1797a8ccce715aea83c2ebcd9338209a75d0107f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fd821b6d121f74f95788b203f2359d6ebec8ee888659321af3ecfc1f9c8e54d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d717f5f5fffa6117ccc5cc19f16601f7aaa0e998835faa498bc9ea5f4a4f28c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfcc69394c6e8ad00a0229d4da01499d4b9e6c8ee515951c81cdc38c66f75ba"
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
