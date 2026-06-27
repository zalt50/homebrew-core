class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1313_SDK.zip"
  version "13.13"
  sha256 "5ea1917bc41b76d5977a2d952d63e17ab16b8d1e1be95a00f573379d794e6683"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6f5e02890d089640341d1f4743b3adf4e9887e08f1c280461bfe762460ade966"
    sha256 cellar: :any, arm64_sequoia: "8c2ef4fc65cc2d990f24ae3c0dc17cfd59f06ea901bc2e90dd91fe1dd6d14961"
    sha256 cellar: :any, arm64_sonoma:  "2ba4e311a4c4641db118e0a80603b5d9bf33ed0205eb28f1e4a925acf8780da0"
    sha256 cellar: :any, sonoma:        "b5c6a9ae4d84eb41ef858edf73a06d4d8ce4cf8e6214180f2d1aaedc0cf67d07"
    sha256 cellar: :any, arm64_linux:   "97fa5c0480ca029d3beba1faee821d828bb8a45be72ad8551b2439e3d766678e"
    sha256 cellar: :any, x86_64_linux:  "f7ae9b1cc829ae4de696fbd1e6eee7775e23bb7e0982de05b6363f48cb7ac05f"
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
