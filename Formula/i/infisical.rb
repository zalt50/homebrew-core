class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.102.tar.gz"
  sha256 "55ab5d504746e166e939590e97619d52b59d5a311ce5b5ab33d6210d254f8c89"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d252b2e1d4403a959935832ed83fe4ec2c93bd3f2427161234b684d3336539a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d252b2e1d4403a959935832ed83fe4ec2c93bd3f2427161234b684d3336539a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d252b2e1d4403a959935832ed83fe4ec2c93bd3f2427161234b684d3336539a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a18a708eeeea327c2c690e6cfca0342c5f792086a9c136deb6def098e7a5f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc05feb7bfabd5205e60a5bf9e77768b90e57a8cf277795582b4cd62fe918d06"
    sha256 cellar: :any,                 x86_64_linux:  "dfa02948c3320826892d354b3809c98cfe46641b5636d2cc4197fc142a894a91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
