class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "c78d2c0255c78cb059fdfa3ed00ec22dfc17735137a5662ab43d86d6c8f20f42"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa8cf3cd6c253a47e15ad40dfb9a0755dcd8ae3e545f4bd9dde5919b44a2f9bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3faf3102a787e18e6f3981447fb42d6cb290aa38b949853ce00c52d05dda8b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4316632aba448cbb00077244eff3d18982f3345a126c341967fa7a6b38729817"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d512112958991b2189e9e70b3693fb26e872f8ff9c133a73761acc195ee413e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "170ff04fd19b5b4810c5d8fc9df5aa70088df0ad929fb87b83ebf95a16f7d93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ced36f76a815e4aad873c1cf885920c3fc6e6fbe3f79a99951bd4dd570b700"
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
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
