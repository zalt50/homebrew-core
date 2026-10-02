class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.4/cmake-4.4.4.tar.gz"
  sha256 "bd24c30d80a7744ae84b845ff080cc8453b06c622ef01066564108e9cefc44cf"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, sonoma:            "10d31af938ee19c2dbb36723891df786854861d82cb3b610d05f9b02527d9f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8f7a63b3cee5dca8a52d6c91373d0777beec8b2ce1747e04a4cba58e17fc1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a8f7a63b3cee5dca8a52d6c91373d0777beec8b2ce1747e04a4cba58e17fc1ff"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  deny_network_access!

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
