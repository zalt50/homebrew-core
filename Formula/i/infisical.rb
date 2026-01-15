class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.47.tar.gz"
  sha256 "72668b94e9a86ada7716c24ee6403b149d43abde97f3d835e635b8cd36eaf4ca"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0525109f960875e0dadfc5f6692d9ac0539179912528c686e534c21aec2672e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0525109f960875e0dadfc5f6692d9ac0539179912528c686e534c21aec2672e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0525109f960875e0dadfc5f6692d9ac0539179912528c686e534c21aec2672e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd465a9d2f6520ec34e99fae70e6fd33c4292d90b6712d9e6ab5539beaa78081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8cca9584abc927c5d9bed81153e79345fbc681d3bb4c0100cd33e42a2ab2cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b258382f56fc0b00e686d11ce170b7f10571352c13190ba4c96eba9cf56f013"
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
