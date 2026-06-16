class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "6f23900f767a8f0c50e731e7114268002e2331f3bcf1428da5625188e881343b"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b904f9a6e7a1ce552687f0a96f04a232bf79b22ddad3e3386bd9be79f24532dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b904f9a6e7a1ce552687f0a96f04a232bf79b22ddad3e3386bd9be79f24532dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b904f9a6e7a1ce552687f0a96f04a232bf79b22ddad3e3386bd9be79f24532dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88fc9987a5a569c86b74fba894cc3db9260b39fc13d348e98b9b384dbc436c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9bcd5a83815a010e00565e09e60f700eebdd7bf3cd6bcadd91c20b7199f9bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4194506c006aafa1246f505943f20229a1e3222bbcfee9fe0eca4ea0b5d2b4"
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
