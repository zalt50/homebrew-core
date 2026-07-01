class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1318_SDK.zip"
  version "13.18"
  sha256 "39cbcdbaf7f3e47cde7cfcb671b7a52ba05ee04c91a986d3eca6a653489c6954"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d90e12204a9494bddabbccdbfe77344ceed5aa9ae3dd818ed2d1b9b513ac7d44"
    sha256 cellar: :any, arm64_sequoia: "1dac7457655d22a6c8c973e885d1ad33be5fd2b72132574e8b780112f4a91a0d"
    sha256 cellar: :any, arm64_sonoma:  "75fdceaff635aa75848edcb17bf0ad16935a6ef32a1ff9f9b4bb348def7bbc0c"
    sha256 cellar: :any, sonoma:        "58621121ae4ecce34f9104a0e4e5f6b76414a63056101c47f4065c16219e975b"
    sha256 cellar: :any, arm64_linux:   "261ee74a698826de17397895e5a935cc6758cc758880ce5dd8d15af85d032dc5"
    sha256 cellar: :any, x86_64_linux:  "22af6d125d11a2c15c32d4241d96f6b8859744a966efb700b8f7cea4cb9526b8"
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
