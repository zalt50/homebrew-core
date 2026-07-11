class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://github.com/gradle/gradle-profiler/releases/download/v0.25.2/gradle-profiler-0.25.2.zip"
  sha256 "33a1add6590af522e0d2dc6a0ea8fe7e828128b6f2ac73a00d6d313964550a53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5af3cce0cedc4cca5d7d41e1535fef5f9c804ac5ccf460e27b15b49d956e30ea"
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
