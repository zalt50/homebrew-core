class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2025.5.tar.gz"
    sha256 "fca5041b1fdea6daba167b63e04e55e5059fab40828342126169336643445447"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "7a47e2531cb334982b2a2dd8513dca0a3de4373d"
      version "7a47e2531cb334982b2a2dd8513dca0a3de4373d"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']glslang_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "b824a462d4256d720bebb40e78b9eb8f78bbb305"
      version "b824a462d4256d720bebb40e78b9eb8f78bbb305"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']spirv_headers_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "262bdab48146c937467f826699a40da0fdfc0f1a"
      version "262bdab48146c937467f826699a40da0fdfc0f1a"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']spirv_tools_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f13a92f1904a7217831b416a3e7272cf08e7c8c1599fc1cdf21538b5a49b8f06"
    sha256 cellar: :any,                 arm64_sequoia: "a063f7f50db8978dcb52f36dae50459daa6990e5b8fa7838543301486273405b"
    sha256 cellar: :any,                 arm64_sonoma:  "d52d1ddaca69c31d353f0d023944e47d94a3563d9c17e38b110f4bfded8699d7"
    sha256 cellar: :any,                 sonoma:        "376c3d44b2ad8a48d0921004782644cd28a5d2e0a245a6da4ce63f823829829a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569a4cc1839f7f218feaee7e28bce9816d5e613002959d872986e4d53c18d7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e1488c44b3557dad4fb152414a2a4e175e1a8a232fb7be87ffffff770213e5"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
  # upstream bug report, https://github.com/google/shaderc/issues/1413
  patch :DATA

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    system "cmake", "-S", ".", "-B", "build",
                    "-DSHADERC_SKIP_TESTS=ON",
                    "-DSKIP_GLSLANG_INSTALL=ON",
                    "-DSKIP_SPIRV_TOOLS_INSTALL=ON",
                    "-DSKIP_GOOGLETEST_INSTALL=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lshaderc_shared"
    system "./test"
  end
end

__END__
diff --git a/third_party/CMakeLists.txt b/third_party/CMakeLists.txt
index d44f62a..dffac6a 100644
--- a/third_party/CMakeLists.txt
+++ b/third_party/CMakeLists.txt
@@ -87,7 +87,6 @@ if (NOT TARGET glslang)
       # Glslang tests are off by default. Turn them on if testing Shaderc.
       set(GLSLANG_TESTS ON)
     endif()
-    set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)
     add_subdirectory(${SHADERC_GLSLANG_DIR} glslang)
   endif()
   if (NOT TARGET glslang)
