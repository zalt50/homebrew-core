class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "e010312eac2063fa2d12ec250b141edbcf96cb63ae7f5b4f2ac492a4b84de084"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6bb27a17d36f7511ed93ad4081c4cb1d9d651dd90b53bc986512996b321064e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6bb27a17d36f7511ed93ad4081c4cb1d9d651dd90b53bc986512996b321064e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6bb27a17d36f7511ed93ad4081c4cb1d9d651dd90b53bc986512996b321064e"
    sha256 cellar: :any_skip_relocation, sonoma:        "15da31c92ff2eef17382c4b323952d28186d66c9d4928dcb0b465558f9ad65d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4f693df30d3e761274a73167d9db246904d1a5b394dc7fb35abbc2456dc43eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8101a5a6d373d567b3df025749dfda4bfec0fe6f26b94e191544664aa140b2b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", shell_parameter_format: :cobra)
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end
