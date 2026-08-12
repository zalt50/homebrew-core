class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.2/cpp/avro-cpp-1.12.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.2/cpp/avro-cpp-1.12.2.tar.gz"
  sha256 "5e4cea5d9dc59bbc0e3e1967fd8f8a86b4cb7c1452c4b252561b8137e949f6fd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f35e56a672cf8d1a65f78f197f60ac5d150b048fddb580ca74e9fd503c784b8b"
    sha256 cellar: :any,                 arm64_sequoia: "aa5264f1917927f3f685343124b31c09313c586859540bc902b03158d4f8989c"
    sha256 cellar: :any,                 arm64_sonoma:  "a53f31ef421e8b05a64395839c204ceb958a06f320f984eda2b9d3c9c5c94fea"
    sha256 cellar: :any,                 sonoma:        "80606fa222e24a27963e33edd318f261dadf5f286e51ac70479b3d9bbc1befa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "080d12251a43917ee3c4a1dacdefa49004b5a751f7086ceb587cd668b6eba7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6f9ddd021abcff92b6023d26799fb130a245a254f61f058da1d11980c0aac97"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => [:build, :test] # needed for headers
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Add missing cmake file from git
  resource "avro-cpp-config.cmake.in" do
    url "https://github.com/apache/avro/raw/refs/tags/release-1.12.2/lang/c++/cmake/avro-cpp-config.cmake.in"
    sha256 "0edd19477321eea574be10972f65fc958bd7ae907de1a3974d9bffec238a01e6"

    livecheck do
      formula :parent
    end
  end

  def install
    (buildpath/"cmake").install resource("avro-cpp-config.cmake.in")

    # Boost 1.89+ no longer requires the 'system' component
    boost_replacements = /Boost\s1.70\sREQUIRED\s(CONFIG\s)?COMPONENTS\s?system/
    inreplace "CMakeLists.txt" do |s|
      s.gsub! boost_replacements, "Boost REQUIRED"
      s.gsub! "$<INSTALL_INTERFACE:$<TARGET_NAME_IF_EXISTS:Boost::system>>", ""
      s.gsub! "Boost::system ZLIB::ZLIB", "$<TARGET_NAME_IF_EXISTS:Boost::system> ZLIB::ZLIB"
    end
    inreplace "cmake/avro-cpp-config.cmake.in", boost_replacements, "Boost REQUIRED"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
