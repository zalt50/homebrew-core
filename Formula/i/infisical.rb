class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.109.tar.gz"
  sha256 "1107f08efe34f29d5278becf6c6624f38571adc41bed219b1962c844d89c7627"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea67dc5f57f101ab16307d36abf001b2322a0bba3f6c19e556eb26223c37f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ea67dc5f57f101ab16307d36abf001b2322a0bba3f6c19e556eb26223c37f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ea67dc5f57f101ab16307d36abf001b2322a0bba3f6c19e556eb26223c37f44"
    sha256 cellar: :any_skip_relocation, sonoma:        "30fb2b56e1f2c30ca68fd3027fef463753f572a3f4550cf2807f3311a89b3fb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63759bef6fc3a7b8e83010117b5155d25aa0af524adf7f231dd3411e8ae41334"
    sha256 cellar: :any,                 x86_64_linux:  "dab61f80b0ed37524814e7bf3eb1d333d03e3b4e1437a361d837d6c196327acb"
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
