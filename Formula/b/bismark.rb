class Bismark < Formula
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/bismark-rust-v3.1.0.tar.gz"
  sha256 "638d7b068031b23fca9c3b3ca5a6b0db675a4da9d48975420fa642b584b5e411"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/Bismark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "518b6eab8123951f73fa55bca7e44a5b2999236150b8242b5ebf0add60e24ca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10af470234099771470b3985d418dceabd3162b18d935e5852b6223940bfb7ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5836eea519b2d4da5fa8f0bb2dc7ed9ac67174bcafd9ece56d315cc22ae717c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a1a3df7c383ad62b3ae2ae43d482766aaf9eacee98c8a9542608648bdaf43c"
    sha256 cellar: :any,                 arm64_linux:   "afd805509f3fa7645e3a8fcbd7fce042253a6574b33386ea4936c62be7f12cac"
    sha256 cellar: :any,                 x86_64_linux:  "6762ba9438e00ee612a3dc7481f086df6fff564026caf54f83776192e0efc394"
  end

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
