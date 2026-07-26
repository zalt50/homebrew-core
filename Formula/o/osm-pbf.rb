class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ac7aadc57d218a5186076f55255202ec7d0949c7f334b8b0cec8bdd196cd75d7"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce2e8ac1f29ebcc269e5cd6dc8fa2e73858fa43925b8b22abf8fa28a58bf009c"
    sha256 cellar: :any, arm64_sequoia: "6bcc011510f52c9ebcc16afa2e233ae7d3ebaf78159b55e11b941b9bc4182596"
    sha256 cellar: :any, arm64_sonoma:  "560dd3d615cd29be53fc37b0dbd446beeb0cc813ebe50eee964ae5d5cda33fe9"
    sha256 cellar: :any, sonoma:        "e0ac07bab26a508b448b559ad656275137ed5f16fb9af68e9443c3b7eb5da085"
    sha256               arm64_linux:   "5867429fe78815751b02dc3f3129c05c901b7d57c23650c61d79df5d2dea31a8"
    sha256               x86_64_linux:  "4e29934cc5957733dcb14c213c70ea030de494ceb2ed093a2439166a08382fe6"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "protobuf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "resources/sample.pbf"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <osmpbf/osmpbf.h>

      int main() {
        OSMPBF::BlobHeader header;
        header.set_type("OSMHeader");
        std::cout << header.type() << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, testpath/"test.cpp",
           "-std=c++17",
           "-I#{include}",
           "-I#{formula_opt_include("protobuf")}",
           "-I#{formula_opt_include("abseil")}",
           "-L#{lib}",
           "-L#{formula_opt_lib("protobuf")}",
           "-L#{formula_opt_lib("abseil")}",
           "-losmpbf",
           "-lprotobuf",
           "-labsl_log_internal_check_op",
           "-labsl_log_internal_message",
           "-o", testpath/"test"

    assert_equal "OSMHeader", shell_output(testpath/"test").chomp
  end
end
