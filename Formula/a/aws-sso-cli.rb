class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "aa0675b42fdf88c4bc562a47add334fe0309666cadd7221079314877654e03d3"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94f7d26d2c9c19a3ed17c6a1f1d9f136735e084f00881aba2a33f5496a14e5f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d439e8889e0fc02f24b567aeb21bd71e8e012f7bc0e5616724ea83fe3f51a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d4643c86481fd815a2e497a81fc03b484820ecbb942e0d57dd915c6ee60853"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ab76d3d8a59ffdfc90ca5a2007eccaf70ed5d01fdec5b2ed3425abee6143be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d003364c2f856ce01faabc8299f996b55f15c7550f83cc8b4e485876c185d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64bc97589176fd0c2fbcebdb3eb9b6ea65f3101f73a908459c01c972f3ef103"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"

    generate_completions_from_executable(bin/"aws-sso", "setup", "completions", "--source",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
