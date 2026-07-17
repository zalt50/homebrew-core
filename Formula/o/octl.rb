class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "3b7428a07d73785cd8eb9e633d349a9c215db50e848c72fbeacc38df76200bd0"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c869789eeb5be2c731585eb97eb599ff145811cdde8e812e82838e6902528a7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4c6b550e06328450ec4b0ade576e4553aa591d6c07ba5fad87b494ec8beaf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec90be6dbdf92d4bc67333500f282c117b9b2e16db9aa72ab7881f5225b7b52"
    sha256 cellar: :any_skip_relocation, sonoma:        "07cd59fe7abea5ca293f9427a970a3c464b3406bdfb68d1e77654de7e582ab2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cfde7cd45c2ad574a1267fee28608c4e64f3ba25f20b853d29761a53668af57"
    sha256 cellar: :any,                 x86_64_linux:  "24f79ac04ea9ebab464cc5a46f90eb5b152b9f48b41f805a91d6578edabba3f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/outscale/octl/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "homebrew")

    generate_completions_from_executable(bin/"octl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octl --version")

    assert_match "One CLI to rule them all", shell_output("#{bin}/octl 2>&1")

    config = testpath/"config.json"
    system bin/"octl", "profile", "add", "brew-test",
           "--ak", "AKIADUMMY", "--sk", "SKDUMMY", "--region", "eu-west-2", "--config", config
    assert_match "eu-west-2", shell_output("#{bin}/octl profile list --config #{config}")
  end
end
