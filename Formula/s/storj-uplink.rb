class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.161.6.tar.gz"
  sha256 "02f2f96a0d701e94df842a0e46b5d228a7d5039f5e11bf8f9c7a1bfb556c3a00"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feff8b300d09abcb884f77dc016fafa78087fb1e174940066da5a0a6b74ef3a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feff8b300d09abcb884f77dc016fafa78087fb1e174940066da5a0a6b74ef3a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feff8b300d09abcb884f77dc016fafa78087fb1e174940066da5a0a6b74ef3a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "26f0be0b1b657985cc39da587aab94df25adee03d01e074721f4d1c5ffc0713d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b6adca1a21cc9c12e2bc67adea8551d3b64a9fcc74e5e1f486567d7e192f6fb"
    sha256 cellar: :any,                 x86_64_linux:  "17f4a2ad24dc49397d07a41644cb72411698e4a5fae0eed77ab7fe3397e4734b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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
