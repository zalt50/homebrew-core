class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c3897831e86d3394f4d21a21548df8e758a64e03edad1484cf83202347f352cd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "f2f9a66770f2acf18f6f727efe52943acdeab1506b667edf92b1430e8a449804"
    sha256 arm64_sequoia: "beb390820470fa2c825dc25a14c2d40de8770f9d513ca639085335773571a730"
    sha256 arm64_sonoma:  "58d13f717ae94f13d6cdcef192691b031ea352b85bffd2c0948aa75831a3e59f"
    sha256 arm64_ventura: "5c19013fde907534ed1e008086dd0af7e58f52091820a503058e6d155690a290"
    sha256 sonoma:        "d80d900ac2c58bdc5d66d31e8c843f24809ceb8934688da4d5f08f9f2da755f4"
    sha256 ventura:       "d272e84ab9b72bbff9e33fbf75983668a1cd2196e81e848a439a8ec57eafc1d4"
    sha256 arm64_linux:   "859941094bdbda1e989e0044a4eee8a7c5473251757b1273b433eab4bcf2b5a4"
    sha256 x86_64_linux:  "88fecf14b35168081be6da6a39e1b8326aa94429c2de4d12cd555220f66b2d67"
  end

  depends_on "cmake" => :build
  depends_on "librsvg"
  depends_on "libusb"
  depends_on "qtbase"
  depends_on "qtpositioning"
  depends_on "qtserialport"
  depends_on "qttools"
  depends_on "yaml-cpp"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_UDEV_RULES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    YAML
    system bin/"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end
