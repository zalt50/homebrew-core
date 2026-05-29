class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "602129487eb5df2f67f659438e1b76c18a2b25dc1cdbed396ddf544a75fad45c"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd294927a3419d5a07f132a5dd3ad594d9c2aaee7ae30e2ed1adacfcc4c7ec78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd294927a3419d5a07f132a5dd3ad594d9c2aaee7ae30e2ed1adacfcc4c7ec78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd294927a3419d5a07f132a5dd3ad594d9c2aaee7ae30e2ed1adacfcc4c7ec78"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76d649e19c3ee6ab3e8ebe58ee829cd74709219353ba0efe2d95b9d8ed08716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0515f75c020bbdb372659a2d99994c4c0d6a656417c1b0e500e7426652a6078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74fd01998030963474607d1efad352e957f71d4aea83ab1704781878023f3ea4"
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
