class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/2.17.2.tar.gz"
  sha256 "84ff95cd6d8a4c9e93ab6bf1d9b3892099baaefb0277bcf2edc3eb4948566035"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "33117d3d68eb5e765c817fb88b1c7f5a567d2167c10f529088ee0f0c565f6fbd"
    sha256 cellar: :any,                 arm64_tahoe:       "e794c89e70f0060b0e02caf5c439b3f8a2300a55cfd9f923aa3e7616d68b9e8b"
    sha256 cellar: :any,                 arm64_sequoia:     "5aff480752ccf8c12530d8cbecd3c11ef804452ff751ddc81e89c093980f6623"
    sha256 cellar: :any,                 arm64_sonoma:      "749bdff8f9a6f7c305241e3a90015230113601e6600150e47ea1fa7d879ccc57"
    sha256 cellar: :any,                 sonoma:            "8b216c4a508c451475740893d10f241c24f7ca5c6b23a78efb753d2f72ac05e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a57001fc63b43ce00a3d8c4f02fd7b6d34123752e6684fdfbac73699660497a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c369951fd44567712e4dacb34d20b6a4ad3b729669ddecea0dca256ca74d4cc8"
  end

  depends_on "gperftools"
  depends_on "wget"

  uses_from_macos "perl"
  uses_from_macos "python"
  uses_from_macos "rsync"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Link `merge` against `omp_hack.o` for builds without OpenMP
  patch do
    url "https://github.com/DerrickWood/kraken2/commit/01fb1d90167c720b6ecab3db707587d6406c8df4.patch?full_index=1"
    sha256 "5a09c4b99b8c656ed4c00c0d40670a63525a99bb3a2abbb60019991da8b17cbd"
    type :unofficial
    resolves "https://github.com/DerrickWood/kraken2/pull/1041"
  end

  def install
    system "./install_kraken2.sh", libexec
    %w[k2 kraken2 kraken2-build kraken2-inspect].each do |f|
      bin.install_symlink libexec/f
    end
    pkgshare.install "data"
  end

  test do
    cp pkgshare/"data/Lambda.fa", testpath
    system bin/"kraken2-build", "--add-to-library", "Lambda.fa", "--db", "testdb"
    assert_path_exists "testdb"
  end
end
