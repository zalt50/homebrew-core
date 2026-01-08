class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "bd5756fb2e9f5c275b37ce1d530ac1c98baca0bad6818dcda5c83d6139108a97"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8c2f8ebafa0b1add9f1217251cf0822f7cd385471f24070cd6bc8ee8bf05702"
    sha256 cellar: :any,                 arm64_sequoia: "a78d24b6319552c5fe4a5d35fcc220323bf3444a14442fba3e6daf3f3eb4229a"
    sha256 cellar: :any,                 arm64_sonoma:  "87831a2e64cf404071b0a1975a0ba104c2149fe7dd4c1c04b1a36781bab63e48"
    sha256 cellar: :any,                 arm64_ventura: "13ff3e501f31a5eab5674930dea31ae4bebaed70ba17f7dc6a05442d15a5ce1e"
    sha256 cellar: :any,                 sonoma:        "e22c58771015099a1b1db1feaf3b243a181dc78de09c791a2a796fe77d7c99b3"
    sha256 cellar: :any,                 ventura:       "e5fa2eb61ae09ac8ef2effc66927e8546b9eb267469b3e530f8453e1690f7d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b913ad10a6af5beb4728c4b0b02aead0427122e917d49e9f7d504bee8ea032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c5c5e10bd186bc8fc0ac85f3b97d784ed3255bf683e786a8ae28fddeb394e7"
  end

  depends_on "cmake" => :build

  # Fix test code to compile correctly, remove in next release
  # Issue ref: https://github.com/microsoft/mimalloc/issues/1194
  patch do
    url "https://github.com/microsoft/mimalloc/commit/41faf0a45e31689371f49e5de82e85597eec4b92.patch?full_index=1"
    sha256 "557c259599c85bdddecb418076ea742ef4cef28f66e5917bc011a41c71fd8311"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
