class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.62.tar.gz"
  sha256 "b9dd1c8eb3bd78f467b61da42bc3c4e0495fd6bfb7664d9d041f3f0cf525a23c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d1c6ac9fbc55712e49da72504951e7541f49ad055dd6e48845d341f73c1d446c"
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
