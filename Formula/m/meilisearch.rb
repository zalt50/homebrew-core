class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.48.1.tar.gz"
  sha256 "150fdf26cf47b982b0e474ae4b053b3dc643f6613622476925b938503046579f"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e4344a625834b7470da5b08a8f59420ec832d3d8cd01fc0b0a19f0389f64fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc2956e69f56ee303fef76e2a1a02d0b68272ac814219c861fb56536de0fc232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2496364765d0e0d5f7cc58b2f7e3052cc80f8dddc2f5583de4a8afb6bf679d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c1bc20ce8ef2a2532819f1047d8fa908d717a5143c71388169589d07cebcd8"
    sha256 cellar: :any,                 arm64_linux:   "2f5b0af0438d81d716483bc3804aa2c2332bebcabe39a24c1c33d0583070a2fb"
    sha256 cellar: :any,                 x86_64_linux:  "f30a06b6d8dc3b20e1aef88fa733e0f72748019a488fb4366c94f604e12bb89a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
