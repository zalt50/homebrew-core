class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.97.0.tar.gz"
  sha256 "b70c3d50bb42f271613b15cea75063d649f303ec9c36862cbbf28cfccbd01401"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fec2309a0d66422038ffcb47bf2e2ff835d943fb6c1d47a6b49f4a6895f3b591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316a33902a19467813db418a76dc2ea669f9471c829bb16aa64edf9f7cb15745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f8c5a0149203adeb9c42082ddfe1edefdc3f87089aa48f7980eae793095d56"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfe1ed4d5649cc6a30e4a7ea7b66fb24bf2c4f9d7e23fa1e3085f18dab8579b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db09839934755717a558973e119557f4d963bc237725e6f7bf5410ffa9934b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1c40b6b0dbe4d6d0213302f17b25fee055fad92c9a557a8b6a48bcf9efc8c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
