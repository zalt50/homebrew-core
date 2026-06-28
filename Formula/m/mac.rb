class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1316_SDK.zip"
  version "13.16"
  sha256 "5b99491a7da1bd5144371f8b371058ddb1876a5667cf8640ec9fff6c9c0a21f3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5bf2c31dd4dffed4ca530874b6c613b03ca707fce1162c76f96d522c4494a45c"
    sha256 cellar: :any, arm64_sequoia: "9f337ae06588b398bcffb38a2b0c28f66e5c9c3fcba8b31e0310b04c0c6982f4"
    sha256 cellar: :any, arm64_sonoma:  "e00b0e6aeef38a3431a4a01a092cecd8276ad96ea4ea4f8f3e9fa7bf48e7599a"
    sha256 cellar: :any, sonoma:        "8338b89b94ade91b96e218371d89ac323cdfcf53af9de83d887e96c697249062"
    sha256 cellar: :any, arm64_linux:   "5c9aae1ed083c4e615ad64277d47885d5448604ec67a54b9755479345ce13eea"
    sha256 cellar: :any, x86_64_linux:  "51dd9b008a188cff0050af93460b8261563ba755bdda5f5a13410a84d3872648"
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
