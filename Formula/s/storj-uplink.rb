class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.142.4.tar.gz"
  sha256 "7d77444403369a8b3ef4e5f8713d2c0ae2ed1d5505464c4f7970040e0356eff2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56f8def83d5503ceb1dfef16167874104920767cc43f2fe2d39917ac38e70020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f8def83d5503ceb1dfef16167874104920767cc43f2fe2d39917ac38e70020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f8def83d5503ceb1dfef16167874104920767cc43f2fe2d39917ac38e70020"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbd3cbc464a0425032644dd964b0b40540f08a8b792a2e11e9b9bf4fbc92ba62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c930df5b972bd58d9ecc66befc6560ebe29eed1dc0f702de5e9510f5c3d56482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "902395a266db0da10d075f25f04ead1e458a340df74b2cb7295fcbb1038bf3c0"
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
