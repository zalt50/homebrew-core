class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.16.0.tar.gz"
  sha256 "eda2589bf3d76ef65f3a85c7ef4ee74cee92fd7c5cd018a323321167176589d8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "778de1ebfff8a3f91442cfabcde90f9636d6884eb5fa728055fbc470f0f0f0b2"
    sha256 cellar: :any, arm64_sequoia: "1045cb7c5381502c0aa9bb67409ee405aad23c259ecea5a4801fed0f7d80b6fd"
    sha256 cellar: :any, arm64_sonoma:  "7bc3540fda7f682b75a3ab2baf02b386da32e485ce8b1f91e7dda2b47f5f4066"
    sha256 cellar: :any, sonoma:        "85eb263e9ddb396ed2142ff6d42a424a6e0e773b491c4b662ec9ad4ec1cbf83e"
    sha256 cellar: :any, arm64_linux:   "cd7659506c2f15fc24d75ece28ddadab322a0c1a2bfc98ca28d876afca36e1ad"
    sha256 cellar: :any, x86_64_linux:  "9a7bed1e056cfe2e05c2d72bdb36030f8e6e4faf13ad825f9115f9e28012943e"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "47d70322c848012ed801e36841767d7ffb79412d"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad/archive/aae505d3daf73e8a48136ccc7398663f16096712.tar.gz"
    sha256 "cfc713e322f1ec7c9d963a9e25b176937464a39a7e95826ffe588cd0bb9bad62"
  end

  resource "crashpad/third_party/mini_chromium/mini_chromium" do
    url "https://github.com/getsentry/mini_chromium/archive/bcc80d6edf8b49d9bbe7a06fff308c222287b112.tar.gz"
    sha256 "009adf4cce8d3aba9e8d5ecd802cdc60eb87d271a3fb5f356c453b4a4122b219"
  end

  resource "crashpad/third_party/lss/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        revision: "9719c1e1e676814c456b55f5f070eabad6709d31"
  end

  # No recent tagged releases, use the latest commit
  resource "libunwindstack-ndk" do
    url "https://github.com/getsentry/libunwindstack-ndk.git",
        revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1"
  end

  resource "third-party/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        tag:      "v2024.02.01",
        revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0"
  end

  def install
    resources.each { |r| r.stage buildpath/"external"/r.name }
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https://ABC.ingest.us.sentry.io/123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-lsentry", "-o", "test"
    system "./test"
  end
end
