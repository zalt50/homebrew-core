class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.7.tar.gz"
  sha256 "1de171b3b9128e640a1eb94028546bb76b55386916ef767b596e4d8153c90ffa"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d974df7f3b8355959186062da9f9b44fd16076d971f6d013ff722b8ad8b85ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d974df7f3b8355959186062da9f9b44fd16076d971f6d013ff722b8ad8b85ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d974df7f3b8355959186062da9f9b44fd16076d971f6d013ff722b8ad8b85ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "af1e81e935522f2b2931f2ce7f498f7ec0fad611bc643517aef4c24fa837036d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8fcc12c6324e1e7de8ae87f5585f0f9f3a15ccb1b0847f4b5d8645162e29993"
    sha256 cellar: :any,                 x86_64_linux:  "f73b4633c24f27e879c370cde4e3906e0b33ff9db4328d01b22d39bcb66090f2"
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
