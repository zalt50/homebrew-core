class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "9045b0b0e355833df29ffa2fbccdbf9269dc85ff56fbb953c2defd6fcd2e5fbb"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be5f3e13d9e607ccd19d9a471bccede85d42e785969931ddbeb95f0c268c44a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc6d086643878059a49259888a94cb1bb05bb6dce0cb4d1e9784c897c7bff63c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c504ce1183ea7dfde794a9e27155320c702761302938b1214694428251e1f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9b0ab790af7812ac30034863bbd22289c1f7a123d0f454cfcc47d5982a219f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08c859be7d4b387c5136541c0cfad16073270a49384fb9b420c4057b67153b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38bae534e81a108b65d84e0d802de14e768346a28d11a44b3a00431a0ee2807d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
