class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 6

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f47aae5a78908c373b416de61546a2ecf2139a0d45b472dd2894fef8e262262"
    sha256 cellar: :any,                 arm64_sequoia: "6fa7769388124822270e8bbfdd561b4df2dfec594c28ea626138d12dfa3b6434"
    sha256 cellar: :any,                 arm64_sonoma:  "6e166ed53159c01eb129da7125f9773ecc44f06c89ff1683a125737b7f98f738"
    sha256 cellar: :any,                 sonoma:        "ff3d6aed126f6a004e1efedd2a39c902955192381a867528a33784b7a6a943b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f8f4380104108c89291d4645ebaa47f1acfcffb0d71aa71f5bcac599f84e97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6570b5c31d5b448085a874b6be15b34b6854914ca36e5ddc4307f4caa46c39a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.14"

  pypi_packages package_name: "nanopb"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/f2/00/04a2ab36b70a52d0356852979e08b44edde0435f2115dc66e25f2100f3ab/protobuf-7.34.0.tar.gz"
    sha256 "3871a3df67c710aaf7bb8d214cc997342e63ceebd940c8c7fc65c9b3d697591a"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=#{venv.site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    PROTO

    system Formula["protobuf"].bin/"protoc", "--nanopb_out=.", "test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
