class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/software-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_39.41.tar.gz"
  sha256 "0b11f00de8081c8a957ce92d902c86bf182afd21fa267e2395d73ccea13141ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c9e163422a5a83ab7a6a5b884b36059800c1eae357ae3ad7edb1a2b98ed7eaf"
    sha256 cellar: :any,                 arm64_sequoia: "2ce3f32e36160f1b79cecc0b1ac582fdfbc262fc424d0937891d458336f106db"
    sha256 cellar: :any,                 arm64_sonoma:  "bcd3fe868f2fd7eba354185f104cae7823f3848d2bf18c3fe22406df0af264fc"
    sha256 cellar: :any,                 sonoma:        "86ba2209c5d400922dcd84f67bb7987150becc8e4b6a86985e4bf0f053190928"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0382248834c797e84a0098925206419e4e3358d6bfea9604bbb62179eb7de696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aeb675eebfa4eb289dcf54dbcd648cc5ac58caffea443fe828ca1a3099587c2"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[current jni resources]
    libexec.install Dir["*.sh"]
    bin.install Dir[libexec/"*.sh"]
    bin.env_script_all_files(libexec, Language::Java.overridable_java_home_env)
    doc.install Dir["docs/*"]
  end

  test do
    res = libexec/"resources"
    args = %W[in=#{res}/sample1.fq.gz
              in2=#{res}/sample2.fq.gz
              out=R1.fastq.gz
              out2=R2.fastq.gz
              ref=#{res}/phix174_ill.ref.fa.gz
              k=31
              hdist=1]

    system bin/"bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
