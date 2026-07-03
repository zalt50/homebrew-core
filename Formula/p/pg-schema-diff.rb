class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "16cb88e0c53f381db4e6601b2c17d223ac484ccb71f5846437e3fbe12793da7c"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56751f38f7a545fe36d1da99918f41adee331ed5fb53e92479d6a3a572497bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56751f38f7a545fe36d1da99918f41adee331ed5fb53e92479d6a3a572497bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56751f38f7a545fe36d1da99918f41adee331ed5fb53e92479d6a3a572497bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecef3291cebc9f28cdc7cec1a7d936db47a7cd6d4b2708a1ab459e14c6d4434c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cca344d3479aff4e2d9796bab1ebfce6d3843bb491e255da9c7ea52aa39cd0c"
    sha256 cellar: :any,                 x86_64_linux:  "bd82139f25c4cfb8101b59e3af56e06bbfb7d9a118a4ead65a9e95af0634c9ce"
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
