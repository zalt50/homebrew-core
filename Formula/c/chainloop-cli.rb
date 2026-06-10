class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.2.tar.gz"
  sha256 "8bd446a4aeda052abc9594a8ffa740f75c8c95b754be14cf78be3881d8cefcfe"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "074e1217736a7208cbf10b1330b38caf52638d5564bf294cd919b2a89dd7634d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e94575a24222c16f54868fa57970f5ab36460218b18d71afbc4d22ed85955bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebbf43ff3c5b80a88acc17bec487e1a93f3633f1988d7a6c70728c797c1ffe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "58498ee326fff97316b80da6fd341b106d871c5bb9a1f34f1c13a4be17326a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88b12fce3e2cfadfdb9898c6115045d1ab42390c53a36b7b3688d337df5df621"
    sha256 cellar: :any,                 x86_64_linux:  "e661d75e15bb08ff06005ade98c8448fdf8395d113c32ac839515b818698e35b"
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
