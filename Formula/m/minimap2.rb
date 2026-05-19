class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.31.tar.gz"
  sha256 "bff334a0e4512644e2f3e29944aeec408f49450f4f74dc39fe89e5273869255b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bab9ae8b3c6ebe68b4cc6ec84c04cefd0a9ed544d474d0b97b3edde63613c029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc2e9667c941db62f475850288cc477af72e76f3f2d601dc5504b33a25054bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea2a7c77af4d26e3121377eaa17fe9f8fda9b195a729f30b0c2b031e71cb79c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9697c3492313510140bb1d4290f854db37f419988e0e141d8c98cd8152e24e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66bf9449ae3f6d95f0fd33af2b2df9c1f556a59e6b1eb53754d5d39bbc3aa80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a23620b041f878b15b147f1eee02ab87b73c26ff1afd8b40bef05503aa141a"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1", "extra"
    else
      system "make", "extra"
    end
    bin.install "minimap2", "sdust"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
