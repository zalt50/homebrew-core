class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.1/cpp/avro-cpp-1.12.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.1/cpp/avro-cpp-1.12.1.tar.gz"
  sha256 "18a0d155905a4dab0c2bfd66c742358a7d969bcff58cf6f655bcf602879f4fe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6704d6e89acb0c747ea276845a9931aba6be8ccb0555ea7333f6fd871d33ef74"
    sha256 cellar: :any,                 arm64_sequoia: "c957d98325e78e380f0350d9c9e96edd4dedf5bc6e066cd3e1cc8149b50c8598"
    sha256 cellar: :any,                 arm64_sonoma:  "b099c4cb40748b37a98350b66ecfaeeca27028731698f061a943aa677cea409b"
    sha256 cellar: :any,                 arm64_ventura: "2bd5f3b4db84283a53fd5ad1378e64fe2be612ba26d542eef7678de2c3a9bc39"
    sha256 cellar: :any,                 sonoma:        "1f97c3b6d551ac12a5709fc8677c5f9383d82f592a55884009fefd14f1c86829"
    sha256 cellar: :any,                 ventura:       "ec11016e755c1c5ccae51e3e6f443a5051ace8c0649129102d047150fada63dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06cd6e6715712951deb88a37597234c495bf65fe08eb54a8b74310007780ac32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae8f2eb793dc55a6deb6907c02445d54feb481060a4c0fdc8bbbbdd3cfb3737"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => [:build, :test] # needed for headers
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "zstd"

  uses_from_macos "zlib"

  # Add missing cmake file from git
  resource "avro-cpp-config.cmake.in" do
    url "https://github.com/apache/avro/raw/refs/tags/release-1.12.1/lang/c++/cmake/avro-cpp-config.cmake.in"
    sha256 "2f100bed5a5ec300bc16e618ef17c64056c165a3dba8dde590a3ef65352440fa"
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
