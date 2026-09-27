class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/releases/download/3.6.0/instead_3.6.0.tar.gz"
  sha256 "ecc15268824d4cbd1d56ba4e44491069accaebaa642a6d275169878492ede80b"
  license "MIT"

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "1c1e5a933c65864ba48dcead307d97932572d6371bce746d265993eef0d0cf85"
    sha256 arm64_tahoe:       "9c66bd5025cd98a1d6728895d208cd9f0fe36a4f5a3ac60f76a9a04a125aeb6c"
    sha256 arm64_sequoia:     "92ce8a6ec45d5ac109f985d8bafb0bd9c6c08563f68e6295013a640bfe1af00b"
    sha256 arm64_linux:       "22d5f39dd5833ac098f6a9048cc0029deab9dd15ad0f05386d10be9ef0d87933"
    sha256 x86_64_linux:      "ffd96d25da618026346183328a2b165143ac9a11a482e329080036444d640b3f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "luajit"
  depends_on "sdl3"
  depends_on "sdl3_image"
  depends_on "sdl3_mixer"
  depends_on "sdl3_ttf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_LUAJIT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/instead -h 2>&1")
  end
end
