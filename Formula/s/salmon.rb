class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "55270240b9eb7d84975f9cf474155c66140393d5e9c265b070cf8cb0bb8b2ea7"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4d8a24976c9d3a1f34b3f73dc7dd826ec49671d50a99ff71998e9871089cd28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7e80aa9c4848acd8a7b740283823ccdd8f3dd69c54cf41e0f7e5ad9928e8e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf575a6b81a3bf6d37a9a7d4ae1b83211ae5eb811aed7a091c37b714d85a4226"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea13a8a5371fce887afca2de4c4fac490e2df7624961bd24194d6cf53502a68e"
    sha256 cellar: :any,                 arm64_linux:   "47355d434b00a1c8edbd6eaad6e998a6902ec5fa9509ed2436ec002ad82be3db"
    sha256 cellar: :any,                 x86_64_linux:  "19cb9c4d025dab5ded66ac97583a6ac715c5551c4bffca6b50ad87408cfb7474"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/salmon-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version")

    (testpath/"txome.fa").write ">t0\n#{"ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT" * 4}\n"
    system bin/"salmon", "index", "-t", "txome.fa", "-i", "idx", "-k", "31"
    assert_predicate testpath/"idx", :directory?
  end
end
