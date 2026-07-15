class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.104.2.tar.gz"
  sha256 "1ba412f0a83cbcfa7f8a899f2a0e3e468a1d2ac8cde97881fadcdbfb9bc22036"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f003cb41d8bdc6ef08a5776cb3abe405f2cd777e5f361fcf887419d445ba9c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f003cb41d8bdc6ef08a5776cb3abe405f2cd777e5f361fcf887419d445ba9c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f003cb41d8bdc6ef08a5776cb3abe405f2cd777e5f361fcf887419d445ba9c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "069febf4fa4113ba7c68aebf387590c8c6c063ff1e750ba8a03bf6961fa87537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096a84b4ea6f80eae603e200080708f96f85ecb718edaba5abda6a659307312b"
    sha256 cellar: :any,                 x86_64_linux:  "09c42160d98333aae07956410edd8c9cdda2b6470b2efa758615510ddaf0fb9a"
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
