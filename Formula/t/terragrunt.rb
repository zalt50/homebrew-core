class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.91.3.tar.gz"
  sha256 "b050c4589ae4886ce8f4681a941c53bb7c7ddd89b9d2820733cfa8b9aab22802"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d80159b0b0d27437f5902f1cce2672e6208b848d28bbe3c5d0a75c883a88aab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d80159b0b0d27437f5902f1cce2672e6208b848d28bbe3c5d0a75c883a88aab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80159b0b0d27437f5902f1cce2672e6208b848d28bbe3c5d0a75c883a88aab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be77e3d6751fdd5cdda5fd0c4a803945bc6b0fa9b4d44640cf0dc4a9034fdc37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b30e6e2b237cffa5adb8d67c4249e1a996d4d72c66e65f4766e8c1dd75690cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13340d169d6d2a4c8e1d976e3acc24403a5c10468ef7c13420da83e0f57bbd37"
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
