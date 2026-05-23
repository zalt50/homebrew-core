class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.49.3.tar.gz"
  sha256 "47004d65f733a9d4ed287d2309adfa00aabeddefffcbe0be74f9ee1de5ca20c0"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ca850b57764eaef409382bce449f48d794c4618f9db9397795db6e0b4461ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2ca850b57764eaef409382bce449f48d794c4618f9db9397795db6e0b4461ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ca850b57764eaef409382bce449f48d794c4618f9db9397795db6e0b4461ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0247881a6ac44e43f0d7f117b81c9a8b7c62a2654f6224eadb68073840d563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f6c153ea9ce3b9a912acd9e9fe5ac2cf8a641eaf81959e79397d358322c002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49faacf9d82508597f5dc4794732124eef09df885a11f1d53482b63b8f5dfcc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
