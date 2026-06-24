class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.97.tar.gz"
  sha256 "f36c0369b70420252de246a9b2ebae7d41d8556f5608ff576df0e489decc915c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8640a1cfa8fd8c80fef63c8dcc603a2e1f5943a291840a939701608aab7980c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8640a1cfa8fd8c80fef63c8dcc603a2e1f5943a291840a939701608aab7980c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8640a1cfa8fd8c80fef63c8dcc603a2e1f5943a291840a939701608aab7980c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "061f00570b2dd430ad295738519032ccfa2f4fed4c74be8ed61ca38fdce5ed9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4d578c44aa40997b4636e2936a720300674667740e42c61f2d7226cb6b2b3b7"
    sha256 cellar: :any,                 x86_64_linux:  "4d8fc0f790ac3a005cb5b63bf09731ccd8e13708877394c0a9c8b196bd5d4f77"
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
