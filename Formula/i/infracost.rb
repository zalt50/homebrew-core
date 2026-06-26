class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b4b11e8d6a6665c9334ba0a537fcdeb7ba8bd7151ef38a73d40eab3b8149adba"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "612a20f9a13514cc8de89d80f5de0a2ddbdb90902747044974c2b40c8d4abb30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "612a20f9a13514cc8de89d80f5de0a2ddbdb90902747044974c2b40c8d4abb30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612a20f9a13514cc8de89d80f5de0a2ddbdb90902747044974c2b40c8d4abb30"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab53d01be1e86b50d0d0eecc4293bbf5d643e774382ddb52c0c713780662522a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa2a99481a86dc01cdf649dc6c6d72c9a9cace0db1805e66dd42d40fed5394c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aaeff9d6810981449bcb2b0bdf9da9435b6d256c6485257645ac9be5f946756"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/cli/version.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"infracost", ldflags:), "main.go"

    generate_completions_from_executable(bin/"infracost", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    ENV["INFRACOST_CLI_AUTHENTICATION_TOKEN"] = "dummy"
    output = shell_output("#{bin}/infracost setup --no-color 2>&1", 1)
    assert_match "setup requires interactive login", output
  end
end
