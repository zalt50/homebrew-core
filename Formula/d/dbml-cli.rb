class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-9.1.0.tgz"
  sha256 "3d7f900a54a2405cf9794fa68ea6d4334b469597737f2b9434d89a17de6b201b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32c76564b16c15637e28c36e06e4f8b50d5efd5698aa301ee18981f263631c7e"
    sha256 cellar: :any,                 arm64_sequoia: "32c76564b16c15637e28c36e06e4f8b50d5efd5698aa301ee18981f263631c7e"
    sha256 cellar: :any,                 arm64_sonoma:  "32c76564b16c15637e28c36e06e4f8b50d5efd5698aa301ee18981f263631c7e"
    sha256 cellar: :any,                 sonoma:        "34e387bf1e690bff57e24cb84601dc567d1baa8a6795f898c070d2816a32c8c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2303b812bfa61a22a3e297402c2ea0f412daf5afa27a7ad8f8f9f01a34424f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac2ca34db81fa58631a8f2902a7f7ef9bd266eb54ac52a58a29644d01a51680"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@dbml/cli/node_modules"
    node_modules.glob("oracledb/build/Release/oracledb-*.node").each do |f|
      rm(f) unless f.basename.to_s.match?("#{os}-#{arch}")
    end

    suffix = OS.linux? ? "-gnu" : ""
    node_modules.glob("snowflake-sdk/dist/lib/minicore/binaries/sf_mini_core_*.node").each do |f|
      rm(f) unless f.basename.to_s.match?("#{os}-#{arch}#{suffix}")
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~SQL
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    SQL

    expected_dbml = <<~SQL
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    SQL

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
