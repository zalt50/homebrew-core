class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "84abfb79bfbb8489758b76cab6908e6d5de586752892a07dd7d1c887027962cf"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4d305d4bafc55fb97920c21950004f8e40ca4f43ab73cdbd4028e7594ed8ff03"
    sha256 cellar: :any, arm64_sequoia: "63fc590a4872b683b417e33e9031d4f74377513563809e598018a3b431939da3"
    sha256 cellar: :any, arm64_sonoma:  "5179b7118b48e17f4a2d02a0138a6ee450ee6382dcb65bdd50517901a59be6dd"
    sha256 cellar: :any, sonoma:        "834c274742d7ec449cf8a1bdd2c9f1d64312d83cc25beca0d1cee94db55e5f2f"
    sha256 cellar: :any, arm64_linux:   "0671ac324c98977b4270ef18c30ae460fad728f4677a65f006ada28e5327a530"
    sha256 cellar: :any, x86_64_linux:  "de3341eb6d9b7b958fd4c635a7984e546aa85ef4753496798792e3923c8c41c0"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
