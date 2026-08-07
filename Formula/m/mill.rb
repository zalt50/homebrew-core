class Mill < Formula
  desc "Fast, scalable JVM build tool"
  homepage "https://mill-build.org/"
  url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/1.1.8/mill-dist-1.1.8.exe"
  sha256 "19d92383f50b373502d94ceb9b1f14280224ee508632641157aad5f4fa66866d"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14de51e91388ff08c558b522d717f014581fdd8482e623e30b08969034ed737c"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~SCALA
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.13.11"
      }
    SCALA
    output = shell_output("#{bin}/mill resolve __.compile 2>&1")
    assert_match "SUCCESS", output
  end
end
