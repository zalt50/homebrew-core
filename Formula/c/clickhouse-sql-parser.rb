class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "cdb1f7b22a488043a0a5698058b84a40a9819ade9ce5e0bf873f33aa045e43fc"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43c390a7329b5f52dcda596847c3141dd47dcf5effb993a2da2fb747726afc91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43c390a7329b5f52dcda596847c3141dd47dcf5effb993a2da2fb747726afc91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c390a7329b5f52dcda596847c3141dd47dcf5effb993a2da2fb747726afc91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1cde365aa217dd98a5b6f27bb5fbb42f9d8101a4fca53f4a3a101797a5044c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654084c1500a1da067ecaaa64761ffd554c77fa4e7621f5fc6dbac8cd873d916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35567d78c8ada6982370b3a67ae5a0294619a5a6b9ef5876036447f474ed5d4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
