class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.33.tar.gz"
  sha256 "55e35217cf5a6f5d1cee3d12d87bd1390b58dd4edf3c39fdd37893f775ee9168"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a063353082d2116e4020282b594aca9d3dc33f0a5edcfe2be38a8b2b67bc025d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a063353082d2116e4020282b594aca9d3dc33f0a5edcfe2be38a8b2b67bc025d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a063353082d2116e4020282b594aca9d3dc33f0a5edcfe2be38a8b2b67bc025d"
    sha256 cellar: :any_skip_relocation, sonoma:        "649dc7d3d77f29bcc361e5961431ba87130e18e9521928b301a092f0ccd5c288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9691c1d3e89f5ee71837df3e8b27c614667b6790f62851e207839846bd664dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d53970918c73a048250e6d0d056eddabc21f9f454884b0f87b1010712b40bf5"
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
