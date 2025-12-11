class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.57.tar.gz"
  sha256 "fdb590811ddfda25a4d217458ad8452ea15b4daa1e238b2d6d38f5f439501c46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a1918862dfa68167c32ddc7dd929fd9aadb870b7d785c90c3c35967b5b0e633"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~SQL
      CREATE TABLE IF NOT EXISTS test (id text);
    SQL
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end
