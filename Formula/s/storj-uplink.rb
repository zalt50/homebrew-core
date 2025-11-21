class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.142.5.tar.gz"
  sha256 "e68892519c9a66e33d7b76a05715bb704b236a1cbb92b194eb0271b89c485e42"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b858ee99036816b617f3607aff96bd3032447267a97687e80517aa1edeadf07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b858ee99036816b617f3607aff96bd3032447267a97687e80517aa1edeadf07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b858ee99036816b617f3607aff96bd3032447267a97687e80517aa1edeadf07"
    sha256 cellar: :any_skip_relocation, sonoma:        "562bba306c7fd4b93df55559ec1edfd2dfabe3c38b3b51403d03df09731db1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d27d932b87be826215e5234c79b2624bd8684282f5ca348516977301d491c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99114c2ba4cb72e80d502cf80632093336c612d60ba818edf10ccc645f74a55b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
