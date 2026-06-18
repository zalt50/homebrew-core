class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.4/cmake-4.3.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.4.tar.gz"
  sha256 "fdeff897b9eb49d764539f2b1edc6eb7e1440df325678a97c1978499e931adda"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f89a08afcd00d26879fb7066e9227446a268d8959a753239fa77f48f70440e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f89a08afcd00d26879fb7066e9227446a268d8959a753239fa77f48f70440e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f89a08afcd00d26879fb7066e9227446a268d8959a753239fa77f48f70440e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f89a08afcd00d26879fb7066e9227446a268d8959a753239fa77f48f70440e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c12efbc966c88e2ae5f885ccb35772938c0a87a684d05f537c7908bb9bff211f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c12efbc966c88e2ae5f885ccb35772938c0a87a684d05f537c7908bb9bff211f"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
