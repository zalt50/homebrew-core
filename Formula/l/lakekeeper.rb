class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "dc3bae836b85405ed33991750f33e6230442274455b10ee5617be09139a525ea"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6ee4c834af397eb58a2442613f644af70239b147d1a9a9c8ede50d58cb8e5837"
    sha256 cellar: :any, arm64_sequoia: "cd48d0b650b7a42410dc874050ae9f38ab60d0420b653d1106b9e7fff16ca96d"
    sha256 cellar: :any, arm64_sonoma:  "37a17d8dd3361a7314fd93ea56130c93c436720a4a97a162c920cf519e5492b6"
    sha256 cellar: :any, sonoma:        "06d5e07c022487ca67bc6eefd9265430ddb56df757e9471228c38a8b5e722f7f"
    sha256 cellar: :any, arm64_linux:   "ed8aacf9362c0267ee1cb1d99246ae87f656cd82304bf19a5ac1aa56efad5068"
    sha256 cellar: :any, x86_64_linux:  "1c109407f4e89cffe5d3ded30cde7494a29d27c367a7e8d46fc3150ff2ef2855"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test", "-o", "-E UTF-8 -U postgres"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["LAKEKEEPER__PG_DATABASE_URL_WRITE"] = "postgres://postgres@localhost:#{port}/postgres"
      output = shell_output("#{bin}/lakekeeper migrate")
      assert_match "Database migration complete", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
