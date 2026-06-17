class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "09b96d4f32e19ecbb5c6e97eca3a4af01d67b95c5a9b35ef1ca41cf50b08a5fe"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8930c735b6dbcb711b610b3a186373e9f4db00f4d414ee2d246d395c7518c723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8930c735b6dbcb711b610b3a186373e9f4db00f4d414ee2d246d395c7518c723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8930c735b6dbcb711b610b3a186373e9f4db00f4d414ee2d246d395c7518c723"
    sha256 cellar: :any_skip_relocation, sonoma:        "465eb705dee60e5eb44f38c49aec8d8022e91aeb20ffeb32f9ec47e1eb51dbc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742e69bf32ace8b1d0295200758892e5c8008879b138b030d423861602ec8ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c654309bb422ff918a1f1b13122e84504c985a22b2b974a72f7d526d15bd0f"
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
