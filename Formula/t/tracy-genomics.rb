class TracyGenomics < Formula
  desc "Basecalling, alignment, assembly and deconvolution of Sanger chromatograms"
  homepage "https://www.gear-genomics.com/docs/tracy/"
  url "https://github.com/gear-genomics/tracy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b4a69e148fed9e69cee251a8c0e1b6964eb1747b6870d207f67d09a8825605b2"
  license "BSD-3-Clause"
  head "https://github.com/gear-genomics/tracy.git", branch: "main"

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Header-only `sdsl-lite`, pulled in as a git submodule upstream.
  resource "sdsl-lite" do
    url "https://github.com/xxsds/sdsl-lite/archive/refs/tags/v3.0.4.tar.gz"
    sha256 "9bade92986d5b6dae15b723f6b2d87b14842e56295558f88c8daaeb33c46967e"
  end

  def install
    resource("sdsl-lite").stage(buildpath/"sdsl-lite")

    system "make", "src/tracy",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}",
           "SDSL_ROOT=#{buildpath}/sdsl-lite"
    bin.install "src/tracy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracy --version")

    (testpath/"ref.fa").write ">chr1\n#{"ACGT" * 20}\n"
    system "gzip", testpath/"ref.fa"

    system bin/"tracy", "index", "-o", "ref.fm9", "ref.fa.gz"
    assert_path_exists testpath/"ref.fm9"
  end
end
