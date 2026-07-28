class Seqwish < Formula
  desc "Alignment to variation graph inducer"
  homepage "https://github.com/pangenome/seqwish"
  url "https://github.com/pangenome/seqwish/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "90d1525c14d6003ff2e498f29b8cca31e947216536230908a6078d54b840372c"
  license "MIT"
  head "https://github.com/pangenome/seqwish.git", branch: "master"

  depends_on "rust" => :build

  def install
    # Upstream builds for the host CPU, which is not portable.
    rm ".cargo/config.toml"

    # The version is baked in from `git describe`, which is unavailable
    # when building from the release tarball.
    ENV["SEQWISH_GIT_VERSION"] = "v#{version}"

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"x.fa").write <<~FASTA
      >a
      GATTACAGATTACAGATTACA
      >b
      GATTACAGATTACAGATTACA
    FASTA
    (testpath/"x.paf").write <<~PAF
      a\t21\t0\t21\t+\tb\t21\t0\t21\t21\t21\t60\tcg:Z:21M
    PAF

    system bin/"seqwish", "-s", "x.fa", "-p", "x.paf", "-g", "x.gfa"

    gfa = (testpath/"x.gfa").read
    assert_match "S\t1\tGATTACAGATTACAGATTACA", gfa
    assert_match "P\ta\t1+", gfa
    assert_match "P\tb\t1+", gfa

    assert_match version.to_s, shell_output("#{bin}/seqwish --version 2>&1")
  end
end
