class Bracken < Formula
  include Language::Python::Shebang

  desc "Bayesian estimation of species abundance from Kraken output"
  homepage "https://ccb.jhu.edu/software/bracken/"
  url "https://github.com/jenniferlu717/Bracken/archive/refs/tags/v3.1.tar.gz"
  sha256 "c0a35331a8aac1e0dbb14c2a92c4de6f89f0aac540101c05c2eec54032107560"
  license "GPL-3.0-or-later"
  head "https://github.com/jenniferlu717/Bracken.git", branch: "master"

  depends_on "kraken2"

  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "make", "-C", "src"

    inreplace ["bracken", "bracken-build"] do |s|
      s.gsub! "$DIR/src/", "#{libexec}/"
      s.gsub! "python #{libexec}/", "#{libexec}/"
    end

    libexec.install "src/est_abundance.py", "src/generate_kmer_distribution.py", "src/kmer2read_distr"
    rewrite_shebang detected_python_shebang(use_python_from_path: true),
      libexec/"est_abundance.py",
      libexec/"generate_kmer_distribution.py"
    bin.install "bracken", "bracken-build"
  end

  test do
    # Exercise Bracken's abundance re-estimation on a minimal Kraken2 report
    # plus a matching kmer distribution, checking the estimated species row.
    report = [
      "50.00\t100\t100\tU\t0\tunclassified",
      "50.00\t100\t0\tR\t1\troot",
      "100.00\t100\t0\tD\t2\t  Bacteria",
      "100.00\t100\t0\tP\t1224\t    Proteobacteria",
      "100.00\t100\t0\tG\t561\t      Escherichia",
      "100.00\t100\t100\tS\t562\t        Escherichia coli",
    ].join("\n")
    (testpath/"report.txt").write "#{report}\n"
    database = testpath/"database"
    database.mkpath
    (database/"database100mers.kmer_distrib").write "562\t562:1000:1000\n"

    system bin/"bracken", "-d", database, "-i", "report.txt", "-o", "abundance.txt",
                          "-r", "100", "-l", "S", "-t", "0"
    assert_match "Escherichia coli\t562\tS\t100", (testpath/"abundance.txt").read
  end
end
