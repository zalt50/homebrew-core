class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "8267fcb4a5891481bc477bb4434ff5c86c3595237aaecbfc9c7bd370eb1fc9a8"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74304e4a14602797d115aab09a0e974cc72b7d71eb8c4052f0f2f19d2092e134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74304e4a14602797d115aab09a0e974cc72b7d71eb8c4052f0f2f19d2092e134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74304e4a14602797d115aab09a0e974cc72b7d71eb8c4052f0f2f19d2092e134"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca1ffd24ecdb68fc8a9e0568bcf9d4d0001ee17e0bb601ffaf6e58a16f836449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efbc0a78ca3671a3089f5ff73cda6c213a730f98e06c27572b277b8814760f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f52f4db385fe2df7c5fa81c4e19da7ad2ba25208d90829014e417ec266ff74"
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
