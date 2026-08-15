class Cuttlefish < Formula
  desc "Build compacted de Bruijn graphs from references or reads"
  homepage "https://combine-lab.github.io/cuttlefish/"
  url "https://github.com/COMBINE-lab/cuttlefish/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "8a6df5044d5daf26d2e728f74b4d0b241ae38e5c9bc76b4513e68b9b60d7cf78"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/cuttlefish.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cuttlefish-rs-cli")
  end

  test do
    seq = "ACGTTGCAATCGGATCCTAGGCATTACGGTTACCGATTCAGGCTAAGTCCATGGCATCAGT"

    (testpath/"ref.fa").write <<~FASTA
      >test
      #{seq}
    FASTA

    system bin/"cuttlefish", "build", "--ref", "--seq", "ref.fa",
           "-k", "31", "-t", "1", "-w", testpath/"work", "-o", testpath/"graph"

    unitigs = (testpath/"graph.fa").read.lines.grep_v(/^>/).map(&:chomp)
    assert_equal 1, unitigs.length
    assert_equal seq.length, unitigs.first.length

    assert_match version.to_s, shell_output("#{bin}/cuttlefish version")
  end
end
