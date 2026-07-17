class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.58.tar.gz"
  sha256 "879d2957413c0fa8c989c141e12a5d45bde0f34d2e4290fb197e05bac7baf774"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1aca779bb8dbd57365c399582cbb6f091d8aad8a0d808e18e2177e07bed81b9"
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
