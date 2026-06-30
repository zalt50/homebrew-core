class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "6e5b778538653bc3ee8b65fbc74028a6edf022ca85179bedea71882699662e89"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbed5a531de58ece95d1f6ffe63f7c18d4440ef4c6030f07a3327a384c666d08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbed5a531de58ece95d1f6ffe63f7c18d4440ef4c6030f07a3327a384c666d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbed5a531de58ece95d1f6ffe63f7c18d4440ef4c6030f07a3327a384c666d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc993153f378db410878786cd6d3d3665039123e03a889f6180911eced1cf78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d490159ce8d078f3c64ea874c688e7237ee01dc20c13836811cc993ffa78b75d"
    sha256 cellar: :any,                 x86_64_linux:  "5b5475df9691af4f82667ce4ed982786774ab4e801179a0e9ee312144f9538fe"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
