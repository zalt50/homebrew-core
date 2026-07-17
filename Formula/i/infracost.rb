class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "0ce201a2d990448c437c28b308dbb231574d70ebc9b7f536bb408b3a244ea55e"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c6d46f713d753731c3b546b5c42628eba6b23e41ea16d88bcc49335ffd2dfb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c6d46f713d753731c3b546b5c42628eba6b23e41ea16d88bcc49335ffd2dfb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6d46f713d753731c3b546b5c42628eba6b23e41ea16d88bcc49335ffd2dfb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b818277727d3bb59d9eea3712158dd5c11a8bc410e8bdf3b86f38f84a4f716e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c795c167946502250c0fb207728f19f3ee755b44cf0a1f06babfd6f499e6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8cbb947fc9d740137a4eca6a3de67f6989a946686e3028299aefce04689b6eb"
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
