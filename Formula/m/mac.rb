class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1164_SDK.zip"
  version "11.64"
  sha256 "67898dd446054c5d59873d983a01a8968cf0fe1bc72e4da2b38b7b89719dbd2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b6f83063e0c7f8abaa38da7280d6c57f7f70986e27f524cc4b6bd117e53f107"
    sha256 cellar: :any,                 arm64_sequoia: "815095cab6518f521bc06a8bd3af660f6d9e4b8f2fd813aec604fb9f64e8afc9"
    sha256 cellar: :any,                 arm64_sonoma:  "3297e0681a2201f8fbdf75de238ae7138964ba2051b5c80954184fd65efd01a7"
    sha256 cellar: :any,                 sonoma:        "bec363277d74c5d7d9cf64458540c76b74b55a2aa62847eabd1512ab4289ecb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e637f67896e7e6fdc2ba365adf09799081af4d3d87af541690e6e50f4820e03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dbc17c710b0260bde60090941731e80e115bd6b02b0a9f13328bd9696e2fb61"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
