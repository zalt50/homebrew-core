class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://www.wartremover.org/"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "dbbc912106b47a8400b6513411c1a28288d021438f5a5e3b3c59165ee297ab6c"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f703c10d4ab2d18e743bfe6c9169aa7602955c275a0836f6c0f670313e07c91d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f703c10d4ab2d18e743bfe6c9169aa7602955c275a0836f6c0f670313e07c91d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f703c10d4ab2d18e743bfe6c9169aa7602955c275a0836f6c0f670313e07c91d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f703c10d4ab2d18e743bfe6c9169aa7602955c275a0836f6c0f670313e07c91d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6584a2237810bda94e9f03cceee46b93ed5138059ec38202d6101e0b4cc32dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6584a2237810bda94e9f03cceee46b93ed5138059ec38202d6101e0b4cc32dfd"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "--server", "assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath/"foo").write <<~SCALA
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    SCALA
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
