class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.43.tar.gz"
  sha256 "696e1f67848359e377e1fb9347b52563bf024e0c554152acc14be6ded7595f76"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2909d2489c42aaab8d37c76332e95daf4745687ac22e0af6382f8f148d51e58f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2909d2489c42aaab8d37c76332e95daf4745687ac22e0af6382f8f148d51e58f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2909d2489c42aaab8d37c76332e95daf4745687ac22e0af6382f8f148d51e58f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca5274e751031d2282c2f92fa3d2e3b94acfad2ff1d6eacea3156dac2cf6947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53c48b746a1864a03cc19d18f0a923dbc10cb6af9f8c708a42fdf30526dc5cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33b28f4d3de0f8eb922bbe5211ef4ff60360299bc8f3b833463889f248a36c3"
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
