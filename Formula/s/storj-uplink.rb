class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.160.1.tar.gz"
  sha256 "b94276892748fe9907c05b20e45e075de703f1e42e3e81a7fd2300a3eec929e0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d0ca4753f66976926b76b607a9cdc8f9703edf954c4a760de96bf80ea00387e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0ca4753f66976926b76b607a9cdc8f9703edf954c4a760de96bf80ea00387e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0ca4753f66976926b76b607a9cdc8f9703edf954c4a760de96bf80ea00387e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e1622bededd627f39a64a35b886fc6d9d2adb40b69d0c115c89538bfbb505d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3730f140e23f8f4022fc3e6e35aa43196d0b9f9ec9a27f41133e1672a838df8f"
    sha256 cellar: :any,                 x86_64_linux:  "3accc2dfd5b7c5849e261b13e31dfaa907a46ba778d6994a03eb993a10fb6dd5"
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
