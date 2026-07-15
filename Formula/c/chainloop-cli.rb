class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.3.tar.gz"
  sha256 "d63fb6069446671eb7f4bd190ade1916642a9f3f1c23f3b61e249bce2ea6b807"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f51dd71445528c8c1f3efc23810aa7664be2c00708ae1cbef04b439cd97023ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f51dd71445528c8c1f3efc23810aa7664be2c00708ae1cbef04b439cd97023ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f51dd71445528c8c1f3efc23810aa7664be2c00708ae1cbef04b439cd97023ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "e347cfa24aced5ada864d5b05ab888d15bc7e1e7f76d21faef16aecaa45bc4d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3d077ee715f5ba0128ad87af64b0e27a7ca41fa3bcf9031d064704e8dcd28c7"
    sha256 cellar: :any,                 x86_64_linux:  "37ca3c02ca01a164cd2c93e2fd77026c2211afc032604a3272fd4bd245a7e4f2"
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
