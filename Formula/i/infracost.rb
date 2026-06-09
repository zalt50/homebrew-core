class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "82de2b0c320277e47824d4de192537363d5bd8ee6baf03173437e29654d99e1f"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b22a34d9ef8a9823461a4f1353d30addd06afd2b0a73abf76d7c64e60840ab1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b22a34d9ef8a9823461a4f1353d30addd06afd2b0a73abf76d7c64e60840ab1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b22a34d9ef8a9823461a4f1353d30addd06afd2b0a73abf76d7c64e60840ab1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0623e0bc1387355515cebdddbc010d37f48db4ff5065fb83d6a333b91f9eb2af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db349292aa0734549a47aab4bcb93f00f6e8881bfa62165b692342fb7d12a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4efcb21ebcb08ca0492af0e423d0f18a9d5ea38c8176f529c0a77955f796a3f3"
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
