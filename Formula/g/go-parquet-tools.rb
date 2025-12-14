class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "55399f0850ca639d7b4eff5527cbb2301a528b34dd2dfb4fefb441973467f192"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a53025ed1813d6ca0464a3cda43c280086fcb7c4ec9e924dc29d7d59d52f1e8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a53025ed1813d6ca0464a3cda43c280086fcb7c4ec9e924dc29d7d59d52f1e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a53025ed1813d6ca0464a3cda43c280086fcb7c4ec9e924dc29d7d59d52f1e8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ec67cc5091bde83369fa618db9e4d2df189dd3bb97d8d142b48a389a11a0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55574c1ae7d39531c55cf4781a505a3fbb179709f27186686e662120efd5a5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a55d4c1c55870a1023da52e64f4c3fd2e6e4af66c17169ff597863db614864"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
