class Rawtoaces < Formula
  desc "Utility for converting camera RAW image files to ACES"
  homepage "https://github.com/AcademySoftwareFoundation/rawtoaces"
  url "https://github.com/AcademySoftwareFoundation/rawtoaces/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "dd4b53d83aaceb4a4ff97914b5bf1b820c929bd1a480d62c263d1849a8aa56dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d7b38645cb3f73a2639b0795478e69de32c713503b5fd507f05e2373aa1c4e0f"
    sha256 arm64_sequoia: "e6954930c57d107f10e997e9bb3c83de9b717cffa31284d9f4791549b9f2b0b5"
    sha256 arm64_sonoma:  "63211d091edf57ab78e703bb416ba42abfa9b2baf270ec34d83acfa89a413055"
    sha256 sonoma:        "9059be7ff2157c5d11762bfdb1099e420ae59481e4403a23c42cd5204ce5a6a7"
    sha256 arm64_linux:   "9f32bd9670be5be8c94efadd6c78339c50eb88fa7faec894fe8703edcf56c218"
    sha256 x86_64_linux:  "0c277ca3cb3f63e5e531674b69997470712cf96ba33a00b08367366c356bba45"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "ceres-solver"
  depends_on "exiftool"
  depends_on "gflags"
  depends_on "glog"
  depends_on "lensfun"
  depends_on "openimageio"

  resource "rawtoaces-data" do
    url "https://github.com/AcademySoftwareFoundation/rawtoaces-data/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "d84051305009e5a154062f837f62d432bc69f7ad9e220f3a57a056ddc9b8911f"
  end

  def install
    # Replace data path to homebrew one
    inreplace "src/rawtoaces_util/image_converter.cpp", "/usr/local/share", "#{HOMEBREW_PREFIX}/share" if OS.linux?

    args = %w[
      -DRTA_INSTALL_DATABASE=OFF
      -DRTA_BUILD_PYTHON_BINDINGS=OFF
      -DRTA_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("rawtoaces-data").stage do
      pkgshare.install "data"
    end
  end

  test do
    expected = "Spectral sensitivity data is available for the following cameras"
    assert_match expected, shell_output("#{bin}/rawtoaces --list-cameras")
  end
end
