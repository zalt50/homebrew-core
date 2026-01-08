class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "ffb84bee8a653e4610c9a2921c866ff758bbc4f5bce84ae8fbe37d2a54d5c7dc"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a31eeb7493aa5f7cde526ed504c50b941f1d430585cdd2abd82c098a4519d981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3c4cba7335f3e013276d7c0c0d34290eb24ce28adba52fb6ebc800849dda68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ad16e743b089f0898cd2fa218a3e1eca8817380f593161cbeb44d913c2e8fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4788946fe6c2e18b7008e074503948174b38dbfbb602cf39b42bf1c46ecf073e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a3077f84c2d3303ab00c53f1883580ae0fb7df9522f52c5b574a86a562122a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "174d16a9b46432ba61ea9beba3efe6da2014a57c1bf00ae14b0a3d843b4447de"
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
    assert_match "run chainloop auth login", output
  end
end
