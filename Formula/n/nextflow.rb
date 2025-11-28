class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.10.1.tar.gz"
  sha256 "d3cde0a53f5197eda44c84e7880f71cff70dc38c5dbc316d5fdada31c454ee4a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be6dbac5484c4d45a9255ebe4e132b64ecc2f0fb9b19f7335f358571f22fd0b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70df71a0b49013ea160cb985822297a680b3bd6a2c339172a227bb688884d957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd82a04273b38dfd729ca46bbea4f9199d8a0e7a6a62e091179d41d7dda39a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e430795ad18608448a71a772904006b5c7989641a018d1ddcbab1763d6f1f2ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db74d33cb015e2847a54d1c5a3453f04447aff1b843fd915a474ea122b09a9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70df71a0b49013ea160cb985822297a680b3bd6a2c339172a227bb688884d957"
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
    (testpath/"hello.nf").write <<~EOS
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
    EOS

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end
