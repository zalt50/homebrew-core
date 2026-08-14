class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.106.0.tar.gz"
  sha256 "a8815c6f85503eaacff1d23b9da6aa671620d13c414c30a90e0f16e75124bb69"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce4eefa52677e76bb8cfdfc0fb211336ba4ec6a04bb2a16e5288341290e32966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4eefa52677e76bb8cfdfc0fb211336ba4ec6a04bb2a16e5288341290e32966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce4eefa52677e76bb8cfdfc0fb211336ba4ec6a04bb2a16e5288341290e32966"
    sha256 cellar: :any_skip_relocation, sonoma:        "59262fd74cd79e23135bbbfdd9c8e7b2972604d4d44f1e6df794967121edf7c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "645385de9eb059b94f0df409cc67fca901cd1d194032d0db3061d3f43a5e8e02"
    sha256 cellar: :any,                 x86_64_linux:  "2091c3cbacef20d25edfb024f895810d76d07450f3c677d01db5ab8b9f161b5a"
  end

  depends_on "go" => :build

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
