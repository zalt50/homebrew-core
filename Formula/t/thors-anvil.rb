class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "8.0.15",
      revision: "d16e8bca49445e95bcdd9eec089e0e8c6c48d108"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6981731546e61ea35875d5d7ede9b53262e8efac6ff8e3ef8eed5230baf372a0"
    sha256 cellar: :any,                 arm64_sequoia: "10946b5448eb9b8568bd004869934d30d748a870bac9c34689de29f3c471db5b"
    sha256 cellar: :any,                 arm64_sonoma:  "45efd5cc7e433d31e6a1bb4efc9d3898ff319fd7f7a5e3e3c00a18968e6210e1"
    sha256 cellar: :any,                 sonoma:        "76498f9ff435020d0f13d308d5fbdd7fef33f2d007549ce8a15f4055018a66a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0207eb2afe7d3abf77fcf2ba229b55ad5bb7fc50ed013fd2b2f60c8747de1664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6462e098d44e9b6db5bc4cf88381d8d71fee9bf3ed3b7682e8d0a221f6321118"
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
