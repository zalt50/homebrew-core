class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.20.tar.gz"
  sha256 "a80374490c02c8849fb4efef06b9b9660dfb17d1ebee1ec4a1a1c1829ebe505d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "564e2653d4e6464adca2c47924473f2cb25f510e5ed975a6755242a1f5bf0852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564e2653d4e6464adca2c47924473f2cb25f510e5ed975a6755242a1f5bf0852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "564e2653d4e6464adca2c47924473f2cb25f510e5ed975a6755242a1f5bf0852"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d783c44f6a3d426236b85e16ce877c731fe954b58a22afbe11b382f5e7bbc1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2c645ebe687c5bdf5e33a42a6736e9d1d3edc67947283bc5e81617ffd65f505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d2da1723c1a11b1e83f81a98c6746c13878ca8417523939d20eda64af18c7e"
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
