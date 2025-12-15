class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.144.3.tar.gz"
  sha256 "59667a5f15818b4e562401bad0abbeaf16fd48a2bb383acbc9bee162339bda38"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "277c63129b02c5053ddce7e447a71f8533b69b08071d89072d63b14947e573f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277c63129b02c5053ddce7e447a71f8533b69b08071d89072d63b14947e573f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "277c63129b02c5053ddce7e447a71f8533b69b08071d89072d63b14947e573f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d86d80920c09de30cc5e71084d9a3b426b14bb0e60872e98bed9c8dab343f5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a427823566eaad67ca0818d5ef96ff23dbd4da41e46ec24773f973537192bded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945a498d0b0408532dd44e9b8becfa5af21df062b6cd6216ab9a619db72fcac5"
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
