class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "11.0.5",
      revision: "5468351d60b22875191b517c7b37b7ddbb859cf4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "373d851f4d65a995a73fdcb7f6549a3f734ffa8d1aa1b10f13f245719f95f96e"
    sha256 cellar: :any, arm64_sequoia: "5c636eeb95381aeeda6bd3da1e3233a8eee963163cdccb024ebff47bce4ca46d"
    sha256 cellar: :any, arm64_sonoma:  "a802bfe79d27300167e94221cdc7dd4b1bcfc17b2c9e9a31652ea3f2601b6fc1"
    sha256 cellar: :any, sonoma:        "3e41c4d0efa6d995794a9b64427bcd578cdfb20f20defba3b1e91d18d773458d"
    sha256 cellar: :any, arm64_linux:   "29f160d6985373f9a0cbac042e04e1ad63e39bc2a0880973318d3849cf5c25c2"
    sha256 cellar: :any, x86_64_linux:  "ea7346f54b838b5ce6b8140e7418163b9fe7c9634271ea0c7666f51c3ba40b97"
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
