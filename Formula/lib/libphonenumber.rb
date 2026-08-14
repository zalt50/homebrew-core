class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/refs/tags/v9.0.36.tar.gz"
  sha256 "43b8fa34f80f84dddc591406d97fbe7f81cf35ce5d83621e67a1b6fa6afac548"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f3cf8dbce68716271a87d89840463d9e033fbfaf8b3d65e096c0e9a8bb8f7f7"
    sha256 cellar: :any, arm64_sequoia: "ba2795daeb1f56aa2b4d1cfbea182d81a658fda5a3034a64ef00c7055d41c2f5"
    sha256 cellar: :any, arm64_sonoma:  "e8a1e7a7066b4502cfdca5486c1170898deaf2f77d486f34d0324b44868b554a"
    sha256 cellar: :any, sonoma:        "03b5cd06ac0d4c39db23b41c0eb40a4031f00df8587adf62d81eaee0e319ba37"
    sha256 cellar: :any, arm64_linux:   "9c61afc6da41c18f93717a028fdb48aad1a8265b92a091c176b8940ce4ca92f3"
    sha256 cellar: :any, x86_64_linux:  "09366c8acca302192fe5771d54dd867f1e70536519bc190b6de5d937f497b561"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "protobuf"

  # Fix build with Boost 1.89.0
  patch do
    url "https://github.com/google/libphonenumber/commit/72c1023fbf00fc48866acab05f6ccebcae7f3213.patch?full_index=1"
    sha256 "6bce9d77b45f35a84ef39831bf2cca793b11aa7b92bd6d71000397d3176f0345"
    type :unofficial
    resolves "https://github.com/google/libphonenumber/pull/3903"
  end

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        std::string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(Boost COMPONENTS date_time system thread)
      find_package(libphonenumber CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test libphonenumber::phonenumber-shared)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
