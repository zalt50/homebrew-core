class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.6.tar.gz"
  sha256 "e2232f1c027a2e4893e82ce7104ee7f6ae0701f9ea9d5b2eb503f181a03e8c33"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2972e662de1af6e0adc7c97438bfb6912a60c1ab6b24c306fd439d8063469cd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c275d710e6dba04dafac3171578e7bb418caae741a8f05bee20c24d7c4daa2f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a32f75d5eea41bdbed59a88999fd5c3ae93f725402c8af5b0ebabf5ba5873a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dba91fde1fe593104c9a4ed0b94aed60b5947c638b5baea0161e0ef638662bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dafccef0071048c61dfc70288b0a5b1ed81975546fd495e08c92a22ac09add28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a65c8a4c31437f8654553056c849bd873c703543a2c8ad16b381a2c566a306c"
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
