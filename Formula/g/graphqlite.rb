class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1f159b8d97394bf822d92c075bf974fe8ed05366e16c2e64050a90d2a8b11403"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c70ce5d165b1a864feb5c4923155a08bfbd46155b95aadc571b37f643b35303"
    sha256 cellar: :any,                 arm64_sequoia: "775d16eec6586128230450b91b3982554c2f9bde969a641bf82cb3f4d140789c"
    sha256 cellar: :any,                 arm64_sonoma:  "06f91b74abafaa593f0ac8858de8c24907400047eb34ffdca52acea2b3eabaa0"
    sha256 cellar: :any,                 sonoma:        "b03d989c555c5a7855d33124fd23455068073557c2b1eaccf45ab2caceb7022d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdaa1b47fba58d0a302caf3fd0abddf865767866eccc9eaae853f5e34fe028b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba3656a026ed8739df416d3db75f0d8290bbc5cc357f657487e1b3db1abeb3dd"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "sqlite"          # macOS sqlite can't load extensions

  uses_from_macos "flex" => :build

  def install
    system "make", "extension", "RELEASE=1"
    lib_ext = OS.mac? ? "dylib" : "so"
    (lib/"sqlite").install "build/graphqlite.#{lib_ext}"
  end

  def caveats
    <<~EOS
      The SQLite extension is installed in #{opt_lib}/sqlite.
      To load it in the SQLite CLI:
        .load #{opt_lib}/sqlite/graphqlite
    EOS
  end

  test do
    sql = <<~SQL
      .load #{opt_lib}/sqlite/graphqlite
      -- Create people
      SELECT cypher('CREATE (a:Person {name: "Alice", age: 30})');
      SELECT cypher('CREATE (b:Person {name: "Bob", age: 25})');
      SELECT cypher('CREATE (c:Person {name: "Charlie", age: 35})');

      -- Create relationships
      SELECT cypher('
          MATCH (a:Person {name: "Alice"}), (b:Person {name: "Bob"})
          CREATE (a)-[:KNOWS]->(b)
      ');
      SELECT cypher('
          MATCH (b:Person {name: "Bob"}), (c:Person {name: "Charlie"})
          CREATE (b)-[:KNOWS]->(c)
      ');

      -- Query friends of friends
      SELECT cypher('
          MATCH (a:Person {name: "Alice"})-[:KNOWS]->()-[:KNOWS]->(fof)
          RETURN fof.name
      ');
    SQL
    assert_match '{"fof.name": "Charlie"}', pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3", sql)
  end
end
