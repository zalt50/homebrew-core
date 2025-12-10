class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.42.tar.gz"
  sha256 "6925b6625a5204832c052ed4ca836d9f6e40b0c2f48cf9e003d3821e12fbf461"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3083ce7d1cbd0507aa82685d053a313dbac572ec383954747edf5a8d28c48cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3083ce7d1cbd0507aa82685d053a313dbac572ec383954747edf5a8d28c48cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3083ce7d1cbd0507aa82685d053a313dbac572ec383954747edf5a8d28c48cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "55598960857f7fc08d35886c220ea972237593d43982e5239fd3afe7f057bd0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f7b2fd91061b51b6a2772c9dc7f94a4f4010c2448eda8a5d5b08e752b8ebfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ac29d9c929d6744922dd9383876b82b6ebe4bc5a9b3787070ff61dc1535b02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
