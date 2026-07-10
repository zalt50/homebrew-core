class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.158.5.tar.gz"
  sha256 "b1bdeb49d83e1ddefa96315a1212c983dd798fa1049e6bafb50136f103b39584"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "127871242fb3bdfa5b67d9983afa4254a8798295fbc9ae44d073457cadeb2923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127871242fb3bdfa5b67d9983afa4254a8798295fbc9ae44d073457cadeb2923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "127871242fb3bdfa5b67d9983afa4254a8798295fbc9ae44d073457cadeb2923"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb91d240acdef9018dbcd726c6120670af13cd9e2f928085846d7ff59185fe1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d39d8969f536d65d73ef3657baef2559bfe9d587660e7e1e9ddf069985fb11e6"
    sha256 cellar: :any,                 x86_64_linux:  "07bba4ad03ccea74c8d186d281abf5ee0c10116fc876a5cd7a7945e76c721032"
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
