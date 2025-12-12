class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.45.tar.gz"
  sha256 "773c289ad3e40d9a79371e872f85dba12bdfdcca262fe966c8fdd3ccbdf69db3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2337961e43c92ecacb750ab34f74604d8a2ac04c4d621f300cd57fee33f451f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2337961e43c92ecacb750ab34f74604d8a2ac04c4d621f300cd57fee33f451f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2337961e43c92ecacb750ab34f74604d8a2ac04c4d621f300cd57fee33f451f"
    sha256 cellar: :any_skip_relocation, sonoma:        "63526d7c52d2e7da46a4703fbf22fba3706b5628f090add4c547a4af446018cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e904affa432cfb0c8dcc3325985e7dd907e88b81f199ed2841cb503156633c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ac17a6fd79b53e9feac890509759785bafea5e4812062c69baf7d745be2a23"
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
