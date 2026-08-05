class Honker < Formula
  desc "SQLite message queue extension"
  homepage "https://honker.dev"
  url "https://static.crates.io/crates/honker-extension/honker-extension-0.4.0.crate"
  sha256 "fde7ef3e6cc439573683730d7bb5f598d804bfc169e0e9c8488e5e59ff762148"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build
  depends_on "sqlite" # macOS sqlite can't load extensions

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"sqlite").install shared_library("target/release/libhonker_ext")
  end

  def caveats
    <<~EOS
      The SQLite extension is installed in #{opt_lib}/sqlite.
      To load it in the SQLite CLI:
        .load #{opt_lib}/sqlite/libhonker_ext
    EOS
  end

  test do
    sql = <<~SQL
      .mode batch
      .load #{opt_lib}/sqlite/libhonker_ext
      SELECT honker_bootstrap();

      SELECT honker_enqueue('greetings', '{"name":"world"}',
                            NULL, NULL, 0, 3, NULL);

      SELECT honker_claim_batch('greetings', 'worker-1', 1, 300);
      -- Then ack the claimed job id from the JSON result above.
      SELECT honker_ack(1, 'worker-1');
    SQL
    expected_output = /1\n1\n\[{.*,"payload":"{\\"name\\":\\"world\\"}","queue":"greetings",.*}\]\n1/
    assert_match expected_output, pipe_output("#{formula_opt_bin("sqlite")}/sqlite3", sql)
  end
end
