class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.25.tar.gz"
  sha256 "f8ea719e7d78957b922a1868bc4f9b8be3f587d01819d3b723009a51e25520e1"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb3df0c9e7378523eba247a6edd825d18b22ab38ede9ea7499ae97994ce7c8bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3df0c9e7378523eba247a6edd825d18b22ab38ede9ea7499ae97994ce7c8bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3df0c9e7378523eba247a6edd825d18b22ab38ede9ea7499ae97994ce7c8bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb1529d4fe801fb527cac243d9b138716ff926a3674b23dfbb6d1021a03fcd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4cfd6288e7c91e5b981e05ea2e51d5d3d1b6219a319bbd6d9d4458998ef12d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56aa5197a854a7598ad21a9da7ca9cf180cf85c0cbcd494e961fd577265e30d8"
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
