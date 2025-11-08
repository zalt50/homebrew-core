class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "1b7a677856f7a14bb8aa4f5dc7188643552be8132fa12f64699ac18cf9aec3f6"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43d707ac25d6c9e4733c293884839b7536a50c0a3c18a3f453f457dc09585461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43d707ac25d6c9e4733c293884839b7536a50c0a3c18a3f453f457dc09585461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43d707ac25d6c9e4733c293884839b7536a50c0a3c18a3f453f457dc09585461"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db0485315e258eeb429dfcd7ee7a6d276617c5355a6e1481d4a8853a2cd0648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b9486518ccf3118792e30c283956f7a4bb628d496d668fb0fa0001d35bc81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e31ea702e7144a80732612b6bfb5d90a08552add2c2c16971a5a46fedaf45b4"
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
