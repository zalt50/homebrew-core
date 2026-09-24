class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.136.tar.gz"
  sha256 "5864fe63d1f6da1b1645d6bc0641cf5cf0f1bafc7906bc3347a963d8c2e6f8c6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b3bab67fcc582aeb3e498c57efca8cf46cd35b493ef518139ad8577781e7bba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b3bab67fcc582aeb3e498c57efca8cf46cd35b493ef518139ad8577781e7bba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b3bab67fcc582aeb3e498c57efca8cf46cd35b493ef518139ad8577781e7bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "595a38a7ce06ef1e6aeb64ede52a46cfae7881a6a665207fcef4c0737c1c8aa4"
    sha256 cellar: :any,                 x86_64_linux:      "389af639a181aa6ad8302e06c443e2fbc23d725eecbe703245642d7225cabe01"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
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
