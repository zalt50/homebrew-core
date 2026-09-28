class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://www.vulkan.org/"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.363.0.tar.gz"
  sha256 "4a078be12bef21cfebc09d878b77a63cff9d68f899254a0b00d0e37ef73e7f7e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^vulkan-sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e270c1c47744b96c606fad05134f6b31e325a4f4f06496c97dafdafde5defd5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fb1c2646ada6cef155a0f358f901f460c778842508ebf42bd1fc853fc8d8525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fb1c2646ada6cef155a0f358f901f460c778842508ebf42bd1fc853fc8d8525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0fb1c2646ada6cef155a0f358f901f460c778842508ebf42bd1fc853fc8d8525"
    sha256 cellar: :any_skip_relocation, tahoe:             "d6fd30c40b9637003108d90c1de3b929b2e0c6f4eb99d463a4b5484680a9cf47"
    sha256 cellar: :any_skip_relocation, sequoia:           "d6fd30c40b9637003108d90c1de3b929b2e0c6f4eb99d463a4b5484680a9cf47"
    sha256 cellar: :any_skip_relocation, sonoma:            "d6fd30c40b9637003108d90c1de3b929b2e0c6f4eb99d463a4b5484680a9cf47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6fd30c40b9637003108d90c1de3b929b2e0c6f4eb99d463a4b5484680a9cf47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d6fd30c40b9637003108d90c1de3b929b2e0c6f4eb99d463a4b5484680a9cf47"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
