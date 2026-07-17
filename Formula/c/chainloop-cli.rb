class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.4.tar.gz"
  sha256 "68cb6ed178e1c37c7e14c6a203b8daaa2bd6f28905fe030c26ef378dfa2c2e64"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fc1977029c70c66043ba2be645099fba98d55773003dbba3c362615d68d0a9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc1977029c70c66043ba2be645099fba98d55773003dbba3c362615d68d0a9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc1977029c70c66043ba2be645099fba98d55773003dbba3c362615d68d0a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b8b9fbb2d6e85959453c43c3118e6c14b5f50b8dae0cae7519ec91a4f2ecef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f8f97193014edddb7421cbbce7a28d77b39c0aef0b78b28499ffe3767abcdc7"
    sha256 cellar: :any,                 x86_64_linux:  "edffbe0703750a18f8fa87f50bff20b1e6363c571e7d7a50dc79083ce7fb9fea"
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
