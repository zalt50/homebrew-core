class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "8.0.09",
      revision: "dcabe4815eec2e30088e90ef3047f2e30076341b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf29582a85bdce501a354f0c5bdf52fff8c1aba4444d0d0daa2ef1980255e267"
    sha256 cellar: :any,                 arm64_sequoia: "1919a23d33ccd54fbaf2b6feda2ae894bb463b610da50266e601a4ce7de54544"
    sha256 cellar: :any,                 arm64_sonoma:  "636f9a2c2e7ad5ca49a9bbc1549febf3fcb58567d938d82428f4b416448ee783"
    sha256 cellar: :any,                 sonoma:        "f14e8b805205b9c30de4168e6f7b93db525ae64135e9148ccd7c23c5cb873f65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9a26efd5212a71006bd5ad90ba10ab4ba06700c6beadbaf56890765e82a9ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ec255c47f74977dff311332867b5f8d77caf51d5d2f228ebf272c291e5f663"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV["COV"] = "gcov"
    # Workaround for failure when building with Xcode std::from_chars
    # src/Serialize/./StringInput.h:104:27: error: call to deleted function 'from_chars'
    ENV.append_to_cflags "-DNO_STD_SUPPORT_FROM_CHAR_DOUBLE=1" if DevelopmentTools.clang_build_version == 1700

    system "./brew/init"
    system "./configure", "--disable-vera",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service",
                          "--disable-slacktest",
                          *std_configure_args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct HomeBrewBlock
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(HomeBrewBlock, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImporter;
          using ThorsAnvil::Serialize::jsonExporter;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          HomeBrewBlock    object;
          inputData >> jsonImporter(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail";
              return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
