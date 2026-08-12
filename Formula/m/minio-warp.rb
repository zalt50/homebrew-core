class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https://github.com/minio/warp"
  url "https://github.com/minio/warp/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "427c6bfa56517b40c5c8a150865bf3e5ae635c7141ef11e71e799ff882a44304"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/warp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e445ca9a04a7f43e9bb84016223ca2b179d7762738b07281ee2657e00d7e35b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526a9943daab7459a912cb26ecc44cf8b644acede5dcfc984ebe7c56ed80cf85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b66c0e82f0dde19958d5cd15f7ade78e3d47b7fb9bc2f1318f7e49c1a0b240"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b30fdfc047d5b87fec4e78dbbdd0a76060319e2c0cde07af27a4ba43fb6407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbfa185eb4ba821c9351716b1ac85fe68e28f7b64d9c9b7bce48e87b225615e6"
    sha256 cellar: :any,                 x86_64_linux:  "e58faf2c3426a9682beff37a18ce50f777ee66fe157f360f0aee717be7612457"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/minio/warp/pkg.ReleaseTag=v#{version}
      -X github.com/minio/warp/pkg.CommitID=#{tap.user}
      -X github.com/minio/warp/pkg.Version=#{version}
      -X github.com/minio/warp/pkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"warp")
  end

  test do
    output = shell_output("#{bin}/warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}/warp --version")
  end
end
