class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.32.tar.gz"
  sha256 "83a5c28613f08715a7f78b91363bd6cb2bdfedd67c827bc1425eb8f93edd33fa"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d737ad5c8b8da7dde40f2633315d4533eb60f30e3460d648138a46b917ba483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b42373c698e1e901f954108e078cb41e9b7116ca47985ab425ce28a6c557dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "254851c67aabe5ab1bd693fcfd5595628f14e3ebc85a39a5659ed0513902f46e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae0825334381909c5481317d21a8168af602829ed24d714b771817db15c3e40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1163ede51eb81d7b434ffe22e46167134bf6090029c52bb9bf85fc0de770a730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ea9896cec4b1fe7a371c383fea08487831bd09f1cb6760ef7a38fd3d629b67a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
