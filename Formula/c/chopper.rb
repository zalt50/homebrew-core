class Chopper < Formula
  desc "Filter and trim long-read sequencing data by quality and length"
  homepage "https://github.com/wdecoster/chopper"
  url "https://github.com/wdecoster/chopper/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f5df330e68e76ceb62f33338be7f7c21bd876e2ad84baa9e50ecbcfdfbd9d232"
  license "MIT"
  head "https://github.com/wdecoster/chopper.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # read1 is 32 bp, read2 is 4 bp; filtering for reads >= 10 bp drops read2
    (testpath/"reads.fq").write <<~EOS
      @read1
      ACGTACGTACGTACGTACGTACGTACGTACGT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
      @read2
      ACGT
      +
      IIII
    EOS

    output = shell_output("#{bin}/chopper -l 10 -i reads.fq")
    assert_includes output, "read1"
    refute_includes output, "read2"
  end
end
