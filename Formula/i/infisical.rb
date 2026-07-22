class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.112.tar.gz"
  sha256 "06b6954170f67cf1d7ac4a414bdfc14625685962a564d33002ff36774417c200"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5523b228042922b07b6dc7a5a4c90cb971d158dcdff38417f742ca160e40c104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5523b228042922b07b6dc7a5a4c90cb971d158dcdff38417f742ca160e40c104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5523b228042922b07b6dc7a5a4c90cb971d158dcdff38417f742ca160e40c104"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfd89e89408485a2d03a0002d02defd396353620115d0f9011ca95c02d14b853"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a20f03a7ec6672699e88fdafbc0e26d1dfc6b924f3a8fe7312499c1ba798b0a"
    sha256 cellar: :any,                 x86_64_linux:  "cf6b1dceefd6789bc924a0dd7790d0751be832d09446f4e513dcfee561d46186"
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
