class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.114.0.tar.gz"
  sha256 "c84a38562b0d7a40d696cb05ca98c99c53397e6adfe0226a949fba27139720b2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bc959b0ad4412bd8016759481394bc56ee8bc603c21837b30caa17f18802ac0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bc959b0ad4412bd8016759481394bc56ee8bc603c21837b30caa17f18802ac0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bc959b0ad4412bd8016759481394bc56ee8bc603c21837b30caa17f18802ac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "36c40b96ee3755d94ac370f2d0ea5f0e543aea9d85b28219a3b0cd7b73ec3d83"
    sha256 cellar: :any,                 x86_64_linux:      "40e85b9b32ca4c85316087bd6fcf03553521c149f97d1d787a5dbed3b99a400c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
