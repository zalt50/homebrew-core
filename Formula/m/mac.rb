class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1170_SDK.zip"
  version "11.70"
  sha256 "b79fe021f23107279721cda750a8686a1790a4f7cfb4b3acceed9bbf778025b4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e087cd3c3eb3659abdcf8a1b50b298d1db1ad6b41b7c7c4e8528951a9327bd50"
    sha256 cellar: :any,                 arm64_sequoia: "165972bee32810fd75059bd9ba1d40ab4d1acb2d2c136c147d4f1c7598901d1d"
    sha256 cellar: :any,                 arm64_sonoma:  "6d409e4aba61aeeca9af413c3f17abb26b9cc8bbb50dd8ffb4b80bc63f1ff78e"
    sha256 cellar: :any,                 sonoma:        "d689c2e6385b9d1930f71f6a1a0732f98abb427ae6d16b51b0c5205e9d36b096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bacddd7e38b05e41d49fc4543db1dd28b62fd4dac13ea4ec5653c3547eec7223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a70e0e87c80a47f786fd5d1e3be4d674f4828d12da45a4a2a48392597a8f197"
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
