class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://developers.google.com/closure/compiler"
  url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/v20260112/closure-compiler-v20260112.jar"
  sha256 "7f57f0d37ada4250d502d0cc78d89b46117f823b863418ce5b43110d3de9d0e3"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/google/javascript/closure-compiler/"
    regex(/href=.*?v?(\d{8})/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c47ef4c822cfdd4d36c5a8bf2f202fce06d2ce199a5694a90e9c5fe2cf4084c"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"closure-compiler-v#{version}.jar", "closure-compiler"
  end

  test do
    (testpath/"test.js").write <<~JS
      (function(){
        var t = true;
        return t;
      })();
    JS
    system bin/"closure-compiler",
           "--js", testpath/"test.js",
           "--js_output_file", testpath/"out.js"
    assert_equal (testpath/"out.js").read.chomp, "(function(){return!0})();"
  end
end
