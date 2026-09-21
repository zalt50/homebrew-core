class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "b3783ae121588b21026949ef7531abacf277aa54763a180b3a19a83ea03329d5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6dca4637d90bbd7d9870bca62ee61cb4e934a926f4b51ff4ecc72f3e57f9f8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6dca4637d90bbd7d9870bca62ee61cb4e934a926f4b51ff4ecc72f3e57f9f8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6dca4637d90bbd7d9870bca62ee61cb4e934a926f4b51ff4ecc72f3e57f9f8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b24a35ad2f304e38907fb4f95aa4dff60c71fd07182d9916f211c397705eef2"
    sha256 cellar: :any,                 x86_64_linux:      "a0136ac6b6a0e45e56d656dad6dec01cc6fe5b6a890e618e903b61fdb4edc3ee"
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
