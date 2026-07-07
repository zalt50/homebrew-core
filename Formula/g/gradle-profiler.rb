class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/0.25.0/gradle-profiler-0.25.0.zip"
  sha256 "911bb597e96f1e4365532820fc352726859e8b6eed85694f98d605a8fa2b4888"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9eccb3ad86ebd582a98c770f366937ccee0193382d0adf0be7d06188beff9a44"
  end

  depends_on "openjdk@21"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env("21")
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler", env
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 8.14 --profile chrome-trace")
    assert_includes output, "* Writing results to"
  end
end
