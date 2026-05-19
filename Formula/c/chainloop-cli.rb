class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.1.tar.gz"
  sha256 "50fe490c0f23009a176693d1ed21adca24e65a7ba45e9b793c8e1eeadac2c24c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4117478828192891dd08a5ee9cabfe1bfab3320d3d1d2668a264edb12825c11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed6cbec5eff8bf126240976f2ed456328c1df70f1db5973c1e4ec235e40b4495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1676df6862d275939e706ff0b53eb18e50ba4fec3ce2393a5087efd36f4f7bbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b26f50bc99a7d2bd5d12eafd20e40fd2eb944dbcdd7d83896457a9fe26ee8c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e09a4f81aa753c0afc8b82f5a291aad7d85b1dc2512f3e341043b8988fd3223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ea80e666edb313c375c8b4d92f5b18e3e3227cd2a0f6618ae931b06e1f4e79"
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
