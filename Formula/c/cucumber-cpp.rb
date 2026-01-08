class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp.git",
      tag:      "v0.8.0",
      revision: "38bd34a3caaeb3fa6ab80d09b323e1a9d6fe24b7"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a84c27a7c5c122364e12ee74e3140a6ccd22656fc6df6da1cf8dc29b3161cf3b"
    sha256 cellar: :any,                 arm64_sequoia: "35387bbcd3b131388528b44ac54f5d695d1fbc9c927d3b172d4793cba0c0ebb0"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5c68f821cd56afe208298382d865e998f272cf64e8c9810a6154d570317176"
    sha256 cellar: :any,                 sonoma:        "9bf81577eead937163e41fcfa5c32bc9d913bca9364a3d5da546cef5a7fd3252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29733451777a0846cf111ee7f5c165009c1a7ae22543252252282006a997b046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aced1fbb5e0c5eefff25bd4a29efdd7a719e1d14e68f915e89d1c04eef0659e"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "ruby" => :test
  depends_on "asio"
  depends_on "tclap"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install "examples"
  end

  test do
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath

    system "gem", "install", "cucumber:9.2.1", "cucumber-wire:7.0.0", "--no-document"

    (testpath/"features/test.feature").write <<~CUCUMBER
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    CUCUMBER
    (testpath/"features/step_definitions/cucumber.wire").write <<~EOS
      host: localhost
      port: 3902
    EOS
    (testpath/"features/support/wire.rb").write <<~RUBY
      require 'cucumber/wire'
    RUBY
    (testpath/"test.cpp").write <<~CPP
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lcucumber-cpp", "-pthread"

    begin
      pid = spawn "./test"
      sleep 1
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test
            Given A given statement
            When A when statement
            Then A then statement

        1 scenario (1 passed)
        3 steps (3 passed)
      EOS
      assert_match expected, shell_output("#{testpath}/bin/cucumber --quiet")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
