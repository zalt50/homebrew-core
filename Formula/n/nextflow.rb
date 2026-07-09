class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.5.tar.gz"
  sha256 "acf5fce5f4d82486b63ee7d429d9a2300c9150242a0cf63904fcdc6770884ece"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82f5d3a06ea5c674dd9afa594bafde09cd832807da715430d95643110fb821fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "294d6942b9ea29776823da1eca9f71bbc6296759c763568ff843a73b0fd43571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d07024ad217ec59054028a7d5a9b4d371e25fae6cd2cd7da8b88a8ef7e9fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ecedc6431926b42cb837c99db06104e4bdd952135fa8aac447d1cf602ea1c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b1d577b6b0df1615888ccad53bfb6dac808459a9ebd0de7075210c061cace0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bf9c80530b1d572a48363f895c74b949b5c982c95e097ad3034f05371df693"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"hello.nf").write <<~NF
      process hello {
        publishDir "results", mode: "copy"

        output:
        path "hello.txt"

        script:
        """
        echo 'Hello!' > hello.txt
        """
      }
      workflow {
        hello()
      }
    NF

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end
