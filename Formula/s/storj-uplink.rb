class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.161.4.tar.gz"
  sha256 "16258e8816445828b8eef83ff6fa27958eda3fe986c6708cda67389dd7f06dfd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6291550961da1192130dd4450256830729a22c74e9ea77f1d3c2a2da3a0daf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6291550961da1192130dd4450256830729a22c74e9ea77f1d3c2a2da3a0daf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6291550961da1192130dd4450256830729a22c74e9ea77f1d3c2a2da3a0daf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbcfb6946892022586b2d3b4787ab517f401c149120173e8058f773ff3681dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff5983c1a876cb17248f3b24ca5cafd43380641ab9a8652295a626fb82dcf192"
    sha256 cellar: :any,                 x86_64_linux:  "c1bf731dd92b01d85a868dc591cb74957f1bb001c16323546c0b3015ae5532c3"
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
