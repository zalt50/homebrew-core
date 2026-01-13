class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "25859f2c4600165e1282850734ed8a24765be366640320fb2a1c2186d4c1a60e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42b2d66e5a2707184974246144cb512c5683bf618975cbf5252db31a77f212a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec8ef84fcc61fc2cd5aa82d366f2360923bfa6a419505475bb43520986d63bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce9446d4385044b4f926ff1f798d26727e305967c4ce29fe7d4abefe6b8f7b42"
    sha256 cellar: :any_skip_relocation, sonoma:        "f809e0076b0d119a879aa2cedc791af9220f238f0a11e54beae15d86e3d89202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79035ceaed68da75389718a4acb466d61b9929f39d52578847fd291b214f50a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1606dc7f98349d1ad45d8b62a84bae4c245b37e95a566d0c10ad587784c0047f"
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
