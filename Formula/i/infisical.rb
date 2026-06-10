class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.92.tar.gz"
  sha256 "8688ac3a83b493fe2c0591520e8e79cd639e50dc19a4edceb2f15214740f1dec"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48326348184af1e9a4d5f91f3b0fa294814c41aa446516be45abdfdaba56e6ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48326348184af1e9a4d5f91f3b0fa294814c41aa446516be45abdfdaba56e6ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48326348184af1e9a4d5f91f3b0fa294814c41aa446516be45abdfdaba56e6ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb49ad8b4a8fea832a9ba0f43cf61282530a7cdc32000158e4e3dc5a2185371d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74db2e4acc18490c336c49f51e39250a3edda66ca20a6ef5a8d35b7e1144f428"
    sha256 cellar: :any,                 x86_64_linux:  "b4c61b15cabf533afa7109141e1906cece54d28b7678bbe3b4015df22bb36c1b"
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
