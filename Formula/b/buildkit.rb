class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "2307112b30593fb8fc4d479ce4547862fa101fa2ecd50a852330a1117a988bbc"
  license "Apache-2.0"
  revision 1
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3ca0f23931d989d241869ec59fd6590eda659c8626a02fa4c0fac1ee94c7c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ca0f23931d989d241869ec59fd6590eda659c8626a02fa4c0fac1ee94c7c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ca0f23931d989d241869ec59fd6590eda659c8626a02fa4c0fac1ee94c7c5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "131202a351452d4e8e7dd4c3ea0384294bcbff874c405528c721be8cdc61b5e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d040b515b5ab0bb86665aa0646cc8c4e4a16a2946218693c13f41c7283931f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5492ed18cf1c0481df4c77620b7ed6eeca7fc69de85ad3fe6ed64360d88f98c"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install buildkitd
      EOS
    end
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
