class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "2c50b805cbb35c7257b54e739aa71c5d7aa5da3a8b2da5c5bb8f145c3bf02e96"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9017800aea3aa49b70c81d2f08d07335230cb0b83063399729d5dc6ffff3f00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a36647584ffa366fe33f2324141bdbff61ae0e06f110f3a19d73eb58eb0038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dea1febb33e0321aefd77cf61330ebb5281347c644fa2a019d4c0ce2f2ae3f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "37041bf182286e9a019f7bcab31108b2383d9e0f8e1b2bfe476d2e9d5e030917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0910ffe609f50d5e6d391c9f780a1f70391c0a6099b4cdcc8e4bf5ce7dd6cc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd2e5c1b224cb9696bfd1655bca04e15efda00369a5f6f40b15bb32e998abf18"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
