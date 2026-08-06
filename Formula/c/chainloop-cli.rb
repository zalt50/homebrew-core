class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.5.tar.gz"
  sha256 "a3c399c38dfd73edba914395364db7ee98a4fcbb86bd4e3ce13915e67c58d7c2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e51494a31b1f9aa34e6885890838be7b84ccee7d315c05ad5156892cfc6a710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e51494a31b1f9aa34e6885890838be7b84ccee7d315c05ad5156892cfc6a710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e51494a31b1f9aa34e6885890838be7b84ccee7d315c05ad5156892cfc6a710"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d25e4ee6044cb42d83711e61da44af94831654640faea367f1a554d1fde609a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae3b6433aa5c7ee9174d1b3e0bb160f98db2c3ad9e8934df11c175b8c4d7d769"
    sha256 cellar: :any,                 x86_64_linux:  "273bab6741bfbcbb307c97bc58372c73ae85ea485ebce1f304f3755bd945ccd6"
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
