class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.0.0.tar.gz"
  sha256 "da04c2dccd234877d61bc217afa39474eba4aca56f34fc3752ef3bc891c11636"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  depends_on "rust" => :build
  depends_on "bowtie2"
  depends_on "minimap2"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/bismark")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bismark --version")

    (testpath/"genome/chr.fa").write ">chr\n#{"ACGTACACGTGTACGT" * 40}\n"
    system bin/"bismark_genome_preparation", testpath/"genome"
    assert_path_exists testpath/"genome/Bisulfite_Genome"
  end
end
