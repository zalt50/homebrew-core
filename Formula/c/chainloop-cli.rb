class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "3af241a8178c90c391e523332950645ecd3130caff63e6629187a644cb45bb8c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e513c12dfec40d02816b10998e27ea5387e4649f53c4d65422e6888e01afb61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afd90413f6f70c96958d4f826b9ba6d2d8cbe0e2dcd7506220ffe18ef48a31be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c125f80a35305087759368c0fce057790b23e738fd31a33279b1115534536143"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5c25956a4612caa38e4597b35f235764741a6c355475766fc7e4b25d8205366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d87f79d24aab77aa44492a3f260fafe77e8bb364bb9f5a5c28f90e44ae4731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484eafba58600a8f06d342c93ccd1a6931692d87a97fbf6fbdc949d5b903f0bd"
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
