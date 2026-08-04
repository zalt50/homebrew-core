class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.117.tar.gz"
  sha256 "997ca47342b1f5c0290ef449b0a5d3760565381a968a362a08985eb7cf6a8fd8"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baf3b2fb7c1c30a84808023263722adabd564ab7914ec1b28a1e92daa190508a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf3b2fb7c1c30a84808023263722adabd564ab7914ec1b28a1e92daa190508a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf3b2fb7c1c30a84808023263722adabd564ab7914ec1b28a1e92daa190508a"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a68371e85535c0f9cc819a1da16ee8083451327d96fcf3ea405f2b744ba97b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008cb6b6340b2bc222fdccdd9929f4509a513c7ec656ff994420e6e185d292f0"
    sha256 cellar: :any,                 x86_64_linux:  "52e5dfa94ebe20a969de8a6e8048d2a6a552548c7bb4069e83ff31adc204dc7a"
  end

  depends_on "go" => :build

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
