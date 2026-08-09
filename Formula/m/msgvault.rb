class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "2aa8dc6c3228acb8d94920714fe32617dfd85dc6d02d3aa9c0d511df9e330401"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ed0fa973a3d7bbc758bfccfdaaba012a68ccc8969b618b989260aede968d6fb"
    sha256 cellar: :any, arm64_sequoia: "5a39f5691712330321f4021351a5152cbf40cd689999a6722817a2bcb70993de"
    sha256 cellar: :any, arm64_sonoma:  "4ec60304562c04871092ef47b341d077b322b347d19413ba6885771f3c6c363c"
    sha256 cellar: :any, sonoma:        "240d6211b9f4f9677971a3f39adc3a2a3aeec7ab18cfaf6503fba6503aa8ff84"
    sha256 cellar: :any, arm64_linux:   "9b6e2e1006dab3b70ae5e11053b9644a59d255b229cb446744bd0f607afa414a"
    sha256 cellar: :any, x86_64_linux:  "228998da5a91f9525872e985003b66138073bced45a2d871c11004ac5932b2ea"
  end

  depends_on "go" => :build
  depends_on "duckdb"

  uses_from_macos "sqlite" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    # DuckDB is linked dynamically against this formula via the duckdb_use_lib
    # tag, rather than the duckdb-go bindings' vendored static library.
    ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("duckdb")}"
    # sqlite-vec's CGo binding #includes <sqlite3.h>; macOS provides it in the
    # SDK, while Linux needs Homebrew's sqlite headers.
    ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("sqlite")}" if OS.linux?

    ldflags = "-X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5 sqlite_vec duckdb_use_lib"), "./cmd/msgvault"
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath

    system bin/"msgvault", "init-db"
    assert_path_exists testpath/"msgvault.db"

    # Build the analytics cache, which runs DuckDB's Parquet ETL over the (empty)
    # database and so exercises the dynamically linked libduckdb.
    system bin/"msgvault", "build-cache"

    assert_match(/Messages:\s+0/, shell_output("#{bin}/msgvault stats"))
  end
end
