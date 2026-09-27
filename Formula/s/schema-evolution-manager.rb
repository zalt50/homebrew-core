class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.60.tar.gz"
  sha256 "ef011f7cd16bf9b973c13b76492c1dfdc3a695c08eac80de425aa442e0680566"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6d3bf3abfc974e1b9a30ad825c387f6d2517396ff31e3ac3729a7c4d70a7219"
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
