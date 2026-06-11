class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.4.tar.gz"
  sha256 "53699475efb695a29c52575fa01a16066590305b6b4301773a48f31c86117353"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc6c5603d5839d8a7d5c095e434ce3d1a081787dee497d07d2c141c7cb2a9ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7849f37ad23abee9ad6b8436f8f0ae333002d9cb8eed02d493dcdff4a2829544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f15edd5a6bf666f3b0f80fe5269d62216855111f317e82c81f9988536847c04f"
    sha256 cellar: :any_skip_relocation, sonoma:        "baad30c375623b73a0260af6afea235f1def717532f8263bb2b67d7ab5c24752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da107db0fae4ef404fd26584342701265bc6aaed31551e69df617d1e1af3b205"
    sha256 cellar: :any,                 x86_64_linux:  "6fc6c6656f046f313ee17d08d2d7e43016a097c530c508d0fd27e2b4869add85"
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
