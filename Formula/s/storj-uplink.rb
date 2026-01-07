class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.144.4.tar.gz"
  sha256 "bc1cad2ef193c3f4ba3db12242c809a6886d92ffd06dcc6890124733e2fda009"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "999f3e1b00b19912fd3c31f137d6d9481a19af2b55156f06a87a0674bfc67174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "999f3e1b00b19912fd3c31f137d6d9481a19af2b55156f06a87a0674bfc67174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "999f3e1b00b19912fd3c31f137d6d9481a19af2b55156f06a87a0674bfc67174"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b6852ea67281deb23fad4922b14e1591d79ce17e4b476273eb8802a3a7fa897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba6e6229998eb7bebc93f414f3790f45f4d7fac1586e485ea2869c20172306e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ccbe30692852265c82b9cacbfce88c0f5cb145815e244ee4e12fb8fce76a6d"
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
