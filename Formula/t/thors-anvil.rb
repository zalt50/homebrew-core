class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "10.2.1",
      revision: "e24214a39762dc262741cfcc6721c9ded9bd76aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8dd2923cf9c9383ce7c48a4bb1949a253d19cbfc42f1c3ce7c1fff4ff537a2b"
    sha256 cellar: :any,                 arm64_sequoia: "6f02b9a01484a2a0dd385eec3a7ead54c49601a05b7ef87eabe86de4fca2a252"
    sha256 cellar: :any,                 arm64_sonoma:  "99baf1e974422f0b5c46acbb7b8e8887619060f2968612da76a6a97239cb7109"
    sha256 cellar: :any,                 sonoma:        "efa852b19d662d35d36a915af5339299123f3e60d2866e50452a72be5b381147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71bb0625f35346ae38a1b255bfde1285e9dea5700edfdfd0daae8fcbe5349bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52720ebe185700a6d95eda56a1329afb8a290c14a621697474eaa64b6b803c8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    ENV["DISABLE_CONTROL_CODES"] = "TRUE"
    system "make", "-j", "1", "JOBS=" + ENV.make_jobs.to_s
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
