class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.6.tar.gz"
  sha256 "856597f78d4343e1f4f178260afd7be54de81f31687033217a7729df7252bb04"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c19f181fe2720066c1884421cc984aae7a2c2066482ab1bebde969c84abf055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d812b99d332f97b0d2b6addd99d35205c426400ca63b350b2ff28416571348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b6653f321a773f228c37bf0b006983bcd8546c731f592b99159880b2cfe5f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d08811edfb8857f22dd9b8234f05bf5ed84d5f2f037356c4116231e79ee1b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec08ab040056b5a814756186681d079b2d7011c6b095e77c0247bb7562354e56"
    sha256 cellar: :any,                 x86_64_linux:  "a1edf20950b089382b50998e99dd98dbab22b6da66881aa8ab0c2845b183fe40"
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
