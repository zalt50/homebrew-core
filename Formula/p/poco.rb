class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.15.4/poco-1.15.4-all.tar.bz2"
  sha256 "d92e9e6711957a6b4415d4ffe0df5470b229bfa123334865c3b6a065030cd3a8"
  license "BSL-1.0"
  compatibility_version 5
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "028b3383514029bc42540b1738cb5434c431e28fc98afabfb465d8f3aa54ede6"
    sha256 cellar: :any, arm64_tahoe:       "b15821014626a97ab5eb9b10e9f94553a112a95f88ab96ea17bbbc3e4da78a9d"
    sha256 cellar: :any, arm64_sequoia:     "c9d8325f277cc7f673edc9fe0922ebb7bbd24817beae74bae3c6155973e6c679"
    sha256 cellar: :any, arm64_linux:       "ad0aa5f192aae3b68e8b6a59527e3062e1efeff6ae31184e7ce88a1d875b9420"
    sha256 cellar: :any, x86_64_linux:      "5bed170bd518d762383f52c0004924782a7c89b4c5590d7eb611dcf5e853d99b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -DENABLE_DATA_MYSQL=OFF
      -DENABLE_DATA_ODBC=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPOCO_UNBUNDLED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end
