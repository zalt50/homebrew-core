class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/sentencepiece.git", branch: "master"

  stable do
    url "https://github.com/google/sentencepiece/archive/refs/tags/v0.2.2.tar.gz"
    sha256 "92381f713e094a15a1ccff1ac4a5315a4c4b82a99ac1332d6ac53c9dc8e1bcf1"

    # Backport protobuf changes that helps Python module link to built library
    patch :DATA
    patch do
      url "https://github.com/google/sentencepiece/commit/b3138d9d6506394f953f69e4d333f02fe4ba7549.patch?full_index=1"
      sha256 "10c9bb69fe6f175c739558706b48d2544af746c9aa4a0854e83f674e8fc18772"
      type :backport
      resolves "https://github.com/google/sentencepiece/pull/1296"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "04cc7dbd8ea89f54dc2ba80985452abaa1aaaa1c644dbedd40c334a961f94962"
    sha256 arm64_tahoe:       "04c5953f410677d5e8deb67a42ee7953a10ed4e3d253895dc4c4b23b0abbd35f"
    sha256 arm64_sequoia:     "fa58bcba804774439f661438b539885cfdf26c6393e2bbb009599b0c07ec7352"
    sha256 arm64_linux:       "41684851ee90609e8c24579618dc3564963328a09c83ba82ccd264273f389a87"
    sha256 x86_64_linux:      "a392b4de6b2ab1edb6abced8d88214ffa32c9a35c8a8cb68c7980550b468cdfb"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "abseil"
  depends_on "protobuf"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSPM_PROTOBUF_PROVIDER=package",
                    "-DSPM_ABSL_PROVIDER=package",
                    "-DSPM_ENABLE_TCMALLOC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Workaround to link python module to shared sentencepiece
    inreplace "python/setup.py",
              "['libsentencepiece.a', 'libsentencepiece_train.a']",
              "['#{shared_library("libsentencepiece")}', '#{shared_library("libsentencepiece_train")}']"
    sentencepiece_site_packages = prefix/Language::Python.site_packages(python3)/"sentencepiece"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(source: sentencepiece_site_packages)}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args, "./python"

    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system bin/"spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"

    (testpath/"test.py").write <<~PYTHON
      import sentencepiece as spm
      sp = spm.SentencePieceProcessor(model_file='m.model')
      pieces = sp.encode('Hello world', return_type=str)
      print(pieces)
      print(sp.decode(pieces))
    PYTHON
    assert_equal <<~EOS, shell_output("#{python3} test.py")
      ['▁He', 'll', 'o', '▁world']
      Hello world
    EOS
  end
end

__END__
diff --git a/.gitignore b/.gitignore
index 9a96c8698..089f3e0e2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -83,3 +83,4 @@ python/test/sp_*.pickle
 third_party/absl
 
 test_tmp
+build_cpp/
