class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "e2db414eb66618cd0a98de77507db32517a48f6900b06bfb94c0acc4bef5761d"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b054b321fe47489ba6412da34745a902ad53bd37ed9135718b09a86e01e5f217"
    sha256 arm64_sequoia: "c2db05eef240df8525ccd2b1ff5e8a4ea26571351a629155b837b914c5534269"
    sha256 arm64_sonoma:  "2103b05cb696921dc04baf9ee40abe7660a34c45ced18a6c149d8449398b130a"
    sha256 sonoma:        "648ed8b9ba9592f4bea195ff0c689aff8dd5e3360a0752579e4d979de8ca30b8"
    sha256 arm64_linux:   "61fff30959411b71e189f719ff801c32ec4c2529d723943ec41c829da4c349dc"
    sha256 x86_64_linux:  "2993ce02ba5647b7d3659a6593986269b28be50ad527ec2836d22bfc1f880fda"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                                              "-DBUILD_SHARED_LIBS=ON",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
