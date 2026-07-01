class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1317_SDK.zip"
  version "13.17"
  sha256 "e16be873fe0c1eb92d14538746ec4947498dcbd54820de7a91d05b79f74ea6ae"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "864de5d149ac91b0ea76f6adab1c02440240bc5760ae02d34beeba556160182f"
    sha256 cellar: :any, arm64_sequoia: "9d6af3faef0607ce80e2ef02228fcd78d6687c7d893cd9ff4f4a3f7c1885b57a"
    sha256 cellar: :any, arm64_sonoma:  "f49f953499197062b54e1241ac053ff8ef86192a1d778e8eb3a7fc8e3ef8ad32"
    sha256 cellar: :any, sonoma:        "82fc4663412451349db15a7522b2ffd78000fa9dc343089249398b5b25120223"
    sha256 cellar: :any, arm64_linux:   "481ef9834b264f08705991da517a78d6459a68d27e37d8c755fe31f08eefc132"
    sha256 cellar: :any, x86_64_linux:  "1760017e4fb3f566d9eb9ed96f824f333274ac87e79ff59c8460de0386a83131"
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
