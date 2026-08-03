class Bbtools < Formula
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://bbmap.org/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_40.01.tar.gz"
  sha256 "66cc1dd20bd7148e302ca7710e3286e605484939959907de0b00b4cb5d848a21"
  license "BSD-3-Clause"

  # Check for the patched versions
  livecheck do
    url "https://sourceforge.net/projects/bbmap/files/"
    regex(/BBMap[._-]v?(\d+(?:\.\d+)+\w?)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "08c96e1ea7535ec156a9e2bd5b34edfabed12b999edf0c784bcf707de520fecc"
    sha256 cellar: :any, arm64_sequoia: "d2214ce126af1fe6819f74a82f424c9837384fec15f7052b0c3d93e26f4bf400"
    sha256 cellar: :any, arm64_sonoma:  "42e46ee403ef08fefe73dbbfd3db0fc26a0b0d5f3a707fb4e3b508dd479f478c"
    sha256 cellar: :any, sonoma:        "2f6961e3cf7a76323e30b4c9c014d43cbe941ee925c81b8c8b3b4eb4df5a5b1f"
    sha256 cellar: :any, arm64_linux:   "5eafed789741fcb849853f439cc6cc58c60d1493f1a4740f23813e84864f2aba"
    sha256 cellar: :any, x86_64_linux:  "3d3f4396dd03039a47589e3612f2ed2119222d37b130f136626c2bf53d19a739"
  end

  depends_on "openjdk"

  def install
    cd "jni" do
      rm Dir["libbbtoolsjni.*", "*.o"]
      system "make", "-f", OS.mac? ? "makefile.osx" : "makefile.linux"
    end
    libexec.install %w[bbtools.jar jni resources]
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
