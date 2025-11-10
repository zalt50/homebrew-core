class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "fb3424458d301714ac34b165765c5d7edb09e666f88a67da38bc92fa50a73910"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8480ad52829600167086c93c6e6c3e053d923ab416116853fee3f2a362b3d754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47ec3284afe12e41c1730f4f24a5b3deede0b31cb88651f3fd6d830631aeae3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f203c740657afb144e475e83eea218db5cb6b9e34c7a9ea11ec3fe15f7213f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fef55e96988c186d34689f95eab1338bb639ac9d945bcc34eb49603e8ad4f84d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6547316872135612b367af8e197b84c484036a78edbd122b5208521bf8d026d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a38ac0c6ef263d39466b2443f91b6d66408838c7ae709c605f0e00f8bee18be"
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
